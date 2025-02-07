from typing import Optional

from fastapi import HTTPException, status
from lims_utils.auth import GenericUser
from lims_utils.models import Paged
from lims_utils.tables import (
    Atlas,
    BLSession,
    DataCollection,
    DataCollectionGroup,
    ExperimentType,
    GridSquare,
    Proposal,
    Tomogram,
)
from sqlalchemy import func as f
from sqlalchemy import select

from ..models.parameters import DataCollectionSortTypes
from ..models.response import DataCollectionGroupSummaryResponse, DataCollectionSummary
from ..utils.auth import check_session
from ..utils.database import db, unravel
from ..utils.generic import parse_proposal


def get_collection_groups(
    limit: int,
    page: int,
    session: Optional[int],
    proposal: Optional[str],
    search: Optional[str],
    user: GenericUser,
) -> Paged[DataCollectionGroupSummaryResponse]:
    query = (
        select(
            *unravel(DataCollectionGroup),
            ExperimentType.name.label("experimentTypeName"),
            DataCollection.imageDirectory,
            f.count(DataCollection.dataCollectionId.distinct()).label("collections"),
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
    return db.paginate(check_session(query, user), limit, page, slow_count=True)


def get_collections(
    limit: int,
    page: int,
    groupId: Optional[int],
    search: Optional[str],
    sortBy: DataCollectionSortTypes,
    user: GenericUser,
    onlyTomograms: bool,
) -> Paged[DataCollectionSummary]:
    sort = (
        (Tomogram.globalAlignmentQuality.desc(),DataCollection.dataCollectionId)
        if sortBy == "globalAlignmentQuality"
        else (DataCollection.dataCollectionId,)
    )

    base_sub_query = (
        select(
            f.row_number().over(order_by=sort).label("index"),
            *unravel(DataCollection),
            f.count(Tomogram.tomogramId.distinct()).label("tomograms"),
            Tomogram.globalAlignmentQuality,
        )
        .select_from(DataCollection)
        .join(DataCollectionGroup)
        .join(BLSession, BLSession.sessionId == DataCollectionGroup.sessionId)
        .join(Tomogram, isouter=(not onlyTomograms))
        .group_by(DataCollection.dataCollectionId)
        .order_by(*sort)
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

    return db.paginate(query, limit, page, slow_count=True)


def get_grid_squares(dcg_id: int, limit: int, page: int, hide_uncollected: bool = False):
    query = (
        select(GridSquare)
        .select_from(Atlas)
        .filter(Atlas.dataCollectionGroupId == dcg_id)
        .join(GridSquare)
    )

    if hide_uncollected:
        query = query.filter(GridSquare.gridSquareImage.is_not(None))

    return db.paginate(query, limit, page, slow_count=True, scalar=False)


def get_atlas(dcg_id: int):
    atlas = db.session.scalar(
        select(Atlas).filter(Atlas.dataCollectionGroupId == dcg_id)
    )

    if atlas is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Data collection group has no atlas",
        )

    return atlas


def get_atlas_image(dcg_id: int):
    atlas_image = db.session.scalar(
        select(Atlas.atlasImage).filter(Atlas.dataCollectionGroupId == dcg_id)
    )

    if atlas_image is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Data collection group has no atlas",
        )

    return atlas_image
