from typing import Optional

from lims_utils.models import Paged
from lims_utils.tables import (
    BLSession,
    DataCollection,
    DataCollectionGroup,
    ExperimentType,
    Proposal,
    Tomogram,
)
from sqlalchemy import func as f
from sqlalchemy import select

from ..auth import User
from ..models.parameters import DataCollectionSortTypes
from ..models.response import DataCollectionGroupSummaryResponse, DataCollectionSummary
from ..utils.auth import check_session
from ..utils.database import db, paginate, unravel
from ..utils.generic import parse_proposal


def get_collection_groups(
    limit: int,
    page: int,
    session: Optional[int],
    proposal: Optional[str],
    search: Optional[str],
    user: User,
) -> Paged[DataCollectionGroupSummaryResponse]:

    query = (
        select(
            *unravel(DataCollectionGroup),
            ExperimentType.name.label("experimentTypeName"),
            DataCollection.imageDirectory,
            f.count(DataCollection.dataCollectionId).label("collections"),
        )
        .select_from(DataCollectionGroup)
        .join(ExperimentType, isouter=True)
        .join(BLSession)
        .join(DataCollection)
        .group_by(DataCollectionGroup.dataCollectionGroupId)
    )

    if search is not None and search != "":
        query = query.filter(DataCollectionGroup.comments.contains(search))

    if proposal:
        proposal_reference = parse_proposal(proposal)
        session_id_query = (
            select(BLSession.sessionId)
            .select_from(Proposal)
            .where(
                Proposal.proposalCode == proposal_reference.code,
                Proposal.proposalNumber == proposal_reference.number,
            )
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
    search: Optional[str],
    sortBy: DataCollectionSortTypes,
    user: User,
    onlyTomograms: bool,
) -> Paged[DataCollectionSummary]:
    sort = (
        Tomogram.globalAlignmentQuality.desc()
        if sortBy == "globalAlignmentQuality"
        else DataCollection.dataCollectionId
    )

    base_sub_query = (
        select(
            f.row_number().over(order_by=sort).label("index"),
            *unravel(DataCollection),
            f.count(Tomogram.tomogramId).label("tomograms"),
            Tomogram.globalAlignmentQuality,
        )
        .select_from(DataCollection)
        .join(DataCollectionGroup)
        .join(BLSession, BLSession.sessionId == DataCollectionGroup.sessionId)
        .join(Tomogram, isouter=(not onlyTomograms))
        .group_by(DataCollection.dataCollectionId)
    )

    sub_with_row = check_session(
        base_sub_query,
        user,
    )

    if groupId is not None:
        sub_with_row = sub_with_row.filter(
            groupId == DataCollection.dataCollectionGroupId
        )

    sub_result = sub_with_row.subquery()

    query = select(*sub_result.c)

    if search is not None and search != "":
        query = query.filter(sub_result.c.comments.contains(search))

    return paginate(query, limit, page, slow_count=True)
