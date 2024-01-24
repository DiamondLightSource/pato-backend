import contextlib
import contextvars
from typing import Generator, Optional, TypeVar

import sqlalchemy.orm
from fastapi import HTTPException, status
from lims_utils.models import Paged
from lims_utils.tables import Base
from sqlalchemy import Select, func, literal_column, select

from .session import _session as sqlsession

_session = contextvars.ContextVar("_session", default=None)


class Database:
    @classmethod
    def set_session(cls, session):
        _session.set(session)

    @property
    def session(cls) -> sqlalchemy.orm.Session:
        try:
            new_session = _session.get()
            if new_session is None:
                raise AttributeError
            return new_session
        except (AttributeError, LookupError):
            raise Exception("Can't get session. Please call Database.set_session()")


db = Database()


@contextlib.contextmanager
def get_session() -> Generator[sqlalchemy.orm.Session, None, None]:
    db_session = sqlsession()
    try:
        Database.set_session(db_session)
        yield db_session
    except Exception:
        db_session.rollback()
        raise
    finally:
        Database.set_session(None)
        db_session.close()


T = TypeVar("T")


def fast_count(query: Select) -> int:
    return db.session.execute(
        query.with_only_columns(func.count(literal_column("1"))).order_by(None)
    ).scalar_one()


def paginate(
    query: Select,
    items: int,
    page: int,
    slow_count=True,
    precounted_total: Optional[int] = None,
):
    if precounted_total is not None:
        total = precounted_total
    elif slow_count:
        total = db.session.execute(
            select(func.count(literal_column("1"))).select_from(query.subquery())
        ).scalar_one()
    else:
        total = fast_count(query)

    if not total:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No items found",
        )

    if page < 0:
        page = (total // items) + page

    data = db.session.execute(query.limit(items).offset((page) * items)).all()

    return Paged(items=data, total=total, limit=items, page=page)


def unravel(model: Base):
    return list(model.__table__.columns)
