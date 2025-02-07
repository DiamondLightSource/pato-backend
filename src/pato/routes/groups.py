from typing import Optional

from fastapi import APIRouter, Depends
from fastapi.responses import FileResponse
from lims_utils.models import Paged, pagination

from ..auth import Permissions, User
from ..crud import groups as crud
from ..models.parameters import DataCollectionSortTypes
from ..models.response import (
    Atlas,
    DataCollectionGroupSummaryResponse,
    DataCollectionSummary,
    GridSquare,
)

router = APIRouter(
    tags=["Data Collection Groups"],
    prefix="/dataGroups",
)


@router.get("", response_model=Paged[DataCollectionGroupSummaryResponse])
def get_collection_groups(
    session: Optional[int] = None,
    proposal: Optional[str] = None,
    page: dict[str, int] = Depends(pagination),
    search: Optional[str] = None,
    user=Depends(User),
):
    """List collection groups belonging to a session"""
    return crud.get_collection_groups(
        session=session, proposal=proposal, search=search, user=user, **page
    )


@router.get("/{groupId}/dataCollections", response_model=Paged[DataCollectionSummary])
def get_collections(
    groupId: Optional[int] = None,
    page: dict[str, int] = Depends(pagination),
    search: Optional[str] = None,
    onlyTomograms: bool = False,
    sortBy: DataCollectionSortTypes = "dataCollectionId",
    user=Depends(User),
):
    """List collections belonging to a data collection group"""
    return crud.get_collections(
        groupId=groupId,
        search=search,
        user=user,
        onlyTomograms=onlyTomograms,
        sortBy=sortBy,
        **page,
    )


@router.get("/{groupId}/grid-squares", response_model=Paged[GridSquare])
def get_grid_squares(
    groupId: int = Depends(Permissions.data_collection_group),
    hideUncollected: bool = False,
    page: dict[str, int] = Depends(pagination),
):
    """Get child grid squares"""
    return crud.get_grid_squares(
        dcg_id=groupId, hide_uncollected=hideUncollected, **page
    )


@router.get("/{groupId}/atlas", response_model=Atlas)
def get_atlas(
    groupId: int = Depends(Permissions.data_collection_group),
):
    """Get atlas"""
    return crud.get_atlas(dcg_id=groupId)


@router.get("/{groupId}/atlas/image", response_class=FileResponse)
def get_atlas_image(
    groupId: int = Depends(Permissions.data_collection_group),
):
    """Get atlas image"""
    return crud.get_atlas_image(dcg_id=groupId)
