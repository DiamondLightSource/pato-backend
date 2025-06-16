from typing import Optional

from fastapi import APIRouter, Body, Depends
from fastapi.responses import FileResponse
from lims_utils.models import Paged, pagination

from ..auth import Permissions, User
from ..crud import alerts as alerts_crud
from ..crud import groups as crud
from ..models.alerts import NotificationSignup
from ..models.collections import DataCollectionSortTypes
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

@router.get("/{groupId}", response_model=DataCollectionGroupSummaryResponse)
def get_collection_group(
    groupId: int = Depends(Permissions.data_collection_group)
):
    """Get data collection group"""
    return crud.get_collection_group(
        group_id=groupId
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
    hideSquares: bool = False,
    page: dict[str, int] = Depends(pagination),
):
    """Get child grid squares"""
    return crud.get_grid_squares(
        dcg_id=groupId, hide_uncollected=hideSquares, **page
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


@router.post("/{groupId}/alerts")
def sign_up_for_alerts(
    user=Depends(User),
    groupId: int = Depends(Permissions.data_collection_group),
    parameters: NotificationSignup = Body(),
):
    """Request alerts for a given email address"""
    alerts_crud.sign_up_for_alerts(user=user, group_id=groupId, parameters=parameters)
