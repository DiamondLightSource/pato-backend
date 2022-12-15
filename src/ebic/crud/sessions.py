from sqlalchemy import and_
from sqlalchemy import func as f
from sqlalchemy import or_
from sqlalchemy.orm import Query

from ..auth import User
from ..models.response import DataCollectionGroupSummaryOut
from ..models.table import (
    BLSession,
    DataCollection,
    DataCollectionGroup,
    SessionHasPerson,
)
from ..utils.auth import is_admin, is_em_staff
from ..utils.database import Paged, db, paginate, unravel

# TODO: Add config file


def check_admin(func):
    def wrap(*args, **kwargs):
        user = args[0]
        query = args[1]

        if is_admin(user.permissions):
            return query

        return func(*args, **kwargs)

    return wrap


@check_admin
def _concat_collection_group_user(user: User, query: Query):
    if is_em_staff(user.permissions):
        return query.join(
            BLSession, BLSession.sessionId == DataCollectionGroup.sessionId
        ).filter(BLSession.beamLineName.like("m__"))

    return query.filter(
        SessionHasPerson.sessionId == DataCollectionGroup.sessionId,
        SessionHasPerson.personId == user.id,
    )


def get_collection_groups(
    items: int, page: int, sessionId: int, search: str, user: User
) -> Paged[DataCollectionGroupSummaryOut]:
    query = (
        db.session.query(
            *unravel(DataCollectionGroup),
            f.count(DataCollection.dataCollectionId).label("collections"),
        )
        .where(
            and_(
                sessionId == DataCollectionGroup.sessionId == sessionId,
                or_(
                    DataCollectionGroup.comments.contains(search),
                    search == "",
                ),
            )
        )
        .join(
            DataCollection,
            DataCollection.dataCollectionGroupId
            == DataCollectionGroup.dataCollectionGroupId,
        )
        .group_by(DataCollectionGroup.dataCollectionGroupId)
    )

    return paginate(_concat_collection_group_user(user, query), items, page)
