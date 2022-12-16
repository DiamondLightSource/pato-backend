from fastapi import APIRouter, Depends

from ..auth import Permissions
from ..crud import collections as crud
from ..models.response import FullMovie, Tomogram
from ..utils.database import Paged
from ..utils.dependencies import pagination

auth = Permissions.collection

router = APIRouter(
    tags=["Data Collections"],
    prefix="/dataCollections",
)


@router.get("/{collectionId}/tomogram", response_model=Tomogram)
def get_tomogram(collectionId: int = Depends(auth)):
    """Get tomogram that belongs to the collection"""
    return crud.get_tomogram(collectionId)


@router.get("/{collectionId}/motion", response_model=Paged[FullMovie])
def get_motion_correction(
    collectionId: int = Depends(auth),
    page: dict[str, int] = Depends(pagination),
):
    """Get motion correction and tilt alignment data (including drift plot)"""
    return crud.get_motion_correction(collectionId=collectionId, **page)
