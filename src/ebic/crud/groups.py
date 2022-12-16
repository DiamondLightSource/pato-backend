from sqlalchemy import and_
from sqlalchemy import func as f
from sqlalchemy import or_

from ..auth import User
from ..models.response import DataCollectionGroupSummaryOut
from ..models.table import BLSession, DataCollection, DataCollectionGroup
from ..utils.auth import check_session
from ..utils.database import Paged, db, paginate, unravel


def get_collection_groups(
    limit: int, page: int, sessionId: int, search: str, user: User
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
        .join(DataCollection)
        .join(BLSession)
        .group_by(DataCollectionGroup.dataCollectionGroupId)
    )

    return paginate(check_session(query, user), limit, page)
