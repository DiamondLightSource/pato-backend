from typing import Optional

from sqlalchemy import func as f
from sqlalchemy import select

from ..auth import User
from ..models.response import DataCollectionGroupSummaryResponse, DataCollectionSummary
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
) -> Paged[DataCollectionGroupSummaryResponse]:
    query = (
        select(
            *unravel(DataCollectionGroup),
            ExperimentType.name.label("experimentTypeName"),
            f.count(DataCollection.dataCollectionId).label("collections"),
        )
        .select_from(DataCollectionGroup)
        .join(ExperimentType, isouter=True)
        .join(BLSession)
        .join(DataCollection)
        .group_by(DataCollectionGroup.dataCollectionGroupId)
    )

    if search != "":
        query = query.filter(DataCollectionGroup.comments.contains(search))

    if proposal:
        session_id_query = (
            select(BLSession.sessionId)
            .select_from(Proposal)
            .where(f.concat(Proposal.proposalCode, Proposal.proposalNumber) == proposal)
            .join(BLSession)
        )

        if session is not None:
            session_id_query = session_id_query.filter(
                BLSession.visit_number == session
            )

            query = query.filter(
                DataCollectionGroup.sessionId == db.session.scalar(session_id_query)
            )
        else:
            query = query.filter(
                DataCollectionGroup.sessionId.in_(
                    db.session.execute(session_id_query).all()
                )
            )

    return paginate(check_session(query, user), limit, page, slow_count=True)


def get_collections(
    limit: int,
    page: int,
    groupId: Optional[int],
    search: str,
    user: User,
    onlyTomograms: bool,
) -> Paged[DataCollectionSummary]:
    sub_with_row = check_session(
        (
            select(
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

    query = select(*sub_result.c)

    if search != "":
        query = query.filter(sub_result.c.comments.contains(search))

    return paginate(query, limit, page, slow_count=True)
