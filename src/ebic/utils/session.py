import contextlib
import os
from typing import Any, Generator

from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker

engine = create_engine(
    url=os.environ.get("SQL_DATABASE_URL", "mysql://admin:admin@localhost:8000/ispyb"),
    pool_pre_ping=True,
    pool_recycle=3600,
    pool_size=os.environ.get("ISPYB_DATABASE_POOL", 10),
    max_overflow=os.environ.get("ISPYB_DATABASE_OVERFLOW", 20),
)

_session = sessionmaker(autocommit=False, autoflush=False, bind=engine)


@contextlib.contextmanager
def get_session() -> Generator[Session, Any, None]:
    session = _session()
    try:
        yield session
        session.commit()
    except:  # noqa
        session.rollback()
        raise
    finally:
        session.close()
