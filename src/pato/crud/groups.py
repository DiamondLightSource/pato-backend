from typing import Optional

from fastapi import HTTPException, status
from lims_utils.auth import GenericUser
from lims_utils.models import Paged, ProposalReference
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
from sqlalchemy.sql.functions import coalesce

from ..models.collections import DataCollectionSortTypes, DataCollectionSummary
from ..models.response import DataCollectionGroupSummaryResponse
from ..utils.auth import check_session
from ..utils.database import db, unravel
from ..utils.generic import validate_path


def get_collection_group(group_id: int):
    return db.session.execute(
        select(
            *unravel(DataCollectionGroup),
            ExperimentType.name.label("experimentTypeName"),
            DataCollection.imageDirectory,
            f.count(DataCollection.dataCollectionId.distinct()).label("collections"),
        )
        .join(DataCollection)
        .join(ExperimentType, isouter=True)
        .group_by(DataCollectionGroup.dataCollectionGroupId)
        .filter(DataCollectionGroup.dataCollectionGroupId == group_id)
    ).one()


def get_collection_groups(
    limit: int,
    page: int,
    proposal_reference: ProposalReference,
    search: Optional[str]
) -> Paged[DataCollectionGroupSummaryResponse]:
    query = (
        select(
            *unravel(DataCollectionGroup),
            ExperimentType.name.label("experimentTypeName"),
            Atlas.atlasId,
            DataCollection.imageDirectory,
            f.count(DataCollection.dataCollectionId.distinct()).label("collections"),
        )
        .select_from(DataCollectionGroup)
        .join(Atlas, isouter=True)
        .join(ExperimentType, isouter=True)
        .join(BLSession)
        .join(Proposal)
        .join(DataCollection)
        .filter(
            Proposal.proposalCode == proposal_reference.code,
            Proposal.proposalNumber == proposal_reference.number,
            BLSession.visit_number == proposal_reference.visit_number,
        )
        .group_by(DataCollectionGroup.dataCollectionGroupId)
    )

    if search is not None and search != "":
        query = query.filter(DataCollectionGroup.comments.contains(search))

    return db.paginate(query, limit, page, slow_count=True)


# TODO: make group ID required
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
        (Tomogram.globalAlignmentQuality.desc(), DataCollection.dataCollectionId)
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

    sub_with_row = check_session(base_sub_query, user, join_proposal=True)

    if groupId is not None:
        sub_with_row = sub_with_row.filter(
            groupId == DataCollection.dataCollectionGroupId
        )

    sub_result = sub_with_row.subquery()

    query = select(*sub_result.c)

    if search is not None and search != "":
        query = query.filter(sub_result.c.comments.contains(search))

    return db.paginate(query, limit, page, slow_count=True)


def get_grid_squares(
    dcg_id: int, limit: int, page: int, hide_uncollected: bool = False
):
    query = (
        select(
            coalesce(GridSquare.pixelLocationX, 0).label("pixelLocationX"),
            coalesce(GridSquare.pixelLocationY, 0).label("pixelLocationY"),
            coalesce(GridSquare.height, 0).label("height"),
            coalesce(GridSquare.width, 0).label("width"),
            coalesce(GridSquare.angle, 0).label("angle"),
            GridSquare.gridSquareId,
            GridSquare.gridSquareImage,
        )
        .select_from(Atlas)
        .filter(Atlas.dataCollectionGroupId == dcg_id)
        .join(GridSquare)
    )

    if hide_uncollected:
        query = query.filter(
            GridSquare.gridSquareImage.is_not(None),
            GridSquare.gridSquareImage != "",
        )

    return db.paginate(query, limit, page, slow_count=True)


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


@validate_path
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
