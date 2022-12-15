from sqlalchemy import and_
from sqlalchemy import func as f
from sqlalchemy import or_
from sqlalchemy.orm import Query

from ..auth import User
from ..models.response import DataCollectionSummaryOut
from ..models.table import BLSession, DataCollection, SessionHasPerson, Tomogram
from ..utils.auth import check_admin, is_em_staff
from ..utils.database import Paged, db, paginate, unravel


@check_admin
def _concat_collection_user(user: User, query: Query):
    if is_em_staff(user.permissions):
        return query.join(
            BLSession, BLSession.sessionId == DataCollection.SESSIONID
        ).filter(BLSession.beamLineName.like("m__"))

    return query.filter(
        SessionHasPerson.sessionId == DataCollection.SESSIONID,
        SessionHasPerson.personId == user.id,
    )


def get_collections(
    items: int, page: int, groupId: int, search: str, user: User
) -> Paged[DataCollectionSummaryOut]:
    tomogram_count = f.count(Tomogram.tomogramId).label("tomograms")
    query = db.session.query(*unravel(DataCollection), tomogram_count)

    cond = and_(
        groupId == DataCollection.dataCollectionGroupId,
        or_(
            DataCollection.comments.contains(search),
            search == "",
        ),
    )

    if True:
        cond.append(tomogram_count > 0)

    return paginate(_concat_collection_user(user, query), items, page)
