from fastapi import APIRouter, Depends

from ..crud import collection as crud
from ..models.api import Unauthorized
from ..models.response import DataCollectionSummaryOut
from ..utils.auth import AuthUser
from ..utils.database import Paged

router = APIRouter(
    tags=["collection"],
    prefix="/dataCollections",
    responses={401: {"model": Unauthorized}},
)


@router.get("", response_model=Paged[DataCollectionSummaryOut])
def collections(
    group: int,
    limit: int = 100,
    page: int = 1,
    s: str = "",
    user=Depends(AuthUser),
):
    """List collections belonging to a data collection group"""
    return crud.get_collections(limit, page, group, s, user)


@router.get("/{id}/tomogram")
def tomograms(id: int, user=Depends(AuthUser)):
    """Get list of tomograms that belong to the collection"""
    return crud.get_tomogram(user, id)


@router.get("/{id}/motion")
def motion(id: int, nth: int = None, user=Depends(AuthUser)):
    """Get motion correction and tilt alignment data (including drift plot)"""
    return crud.get_motion_correction(user, id, nth)
