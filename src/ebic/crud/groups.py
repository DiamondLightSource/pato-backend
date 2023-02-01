from typing import Optional

from sqlalchemy import func as f
from sqlalchemy import or_

from ..auth import User
from ..models.response import DataCollectionGroupSummaryOut, DataCollectionSummaryOut
from ..models.table import (
    BLSession,
    DataCollection,
    DataCollectionGroup,
    ExperimentType,
    Proposal,
    Tomogram,
)
from ..utils.auth import check_session
from ..utils.database import Paged, db, paginate, unravel


def get_collection_groups(
    limit: int,
    page: int,
    session: Optional[int],
    proposal: Optional[str],
    search: str,
    user: User,
) -> Paged[DataCollectionGroupSummaryOut]:
    query = (
        db.session.query(
            *unravel(DataCollectionGroup),
            ExperimentType.name.label("experimentTypeName"),
            f.count(DataCollection.dataCollectionId).label("collections"),
        )
        .select_from(DataCollectionGroup)
        .where(
            or_(
                DataCollectionGroup.comments.contains(search),
                search == "",
            ),
        )
        .join(ExperimentType, isouter=True)
        .join(BLSession)
        .join(DataCollection)
        .group_by(DataCollectionGroup.dataCollectionGroupId)
    )

    if proposal:
        session_id_query = (
            db.session.query(BLSession.sessionId)
            .select_from(Proposal)
            .where(f.concat(Proposal.proposalCode, Proposal.proposalNumber) == proposal)
            .join(BLSession)
        )

        if session is not None:
            session_id_query = session_id_query.filter(
                BLSession.visit_number == session
            )

            query = query.filter(
                DataCollectionGroup.sessionId == session_id_query.scalar()
            )
        else:
            query = query.filter(
                DataCollectionGroup.sessionId.in_(session_id_query.all())
            )

    return paginate(check_session(query, user), limit, page, slow_count=True)


def get_collections(
    limit: int,
    page: int,
    groupId: Optional[int],
    search: str,
    user: User,
    onlyTomograms: bool,
) -> Paged[DataCollectionSummaryOut]:
    sub_with_row = check_session(
        (
            db.session.query(
                f.row_number()
                .over(order_by=DataCollection.dataCollectionId)
                .label("index"),
                *unravel(DataCollection),
                f.count(Tomogram.tomogramId).label("tomograms"),
            )
            .select_from(DataCollection)
            .join(BLSession, BLSession.sessionId == DataCollection.SESSIONID)
            .join(Tomogram, isouter=(not onlyTomograms))
            .group_by(DataCollection.dataCollectionId)
            .order_by(DataCollection.dataCollectionId)
        ),
        user,
    )

    if groupId is not None:
        sub_with_row = sub_with_row.filter(
            groupId == DataCollection.dataCollectionGroupId
        )

    sub_result = sub_with_row.subquery()

    query = db.session.query(*sub_result.c).filter(
        or_(
            sub_result.c.comments.contains(search),
            search == "",
        ),
    )

    return paginate(query, limit, page, slow_count=True)
