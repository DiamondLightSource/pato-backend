from fastapi import APIRouter, Depends

from ..auth import Permissions
from ..crud import collection as crud
from ..models.response import MotionOut, Tomogram

auth = Permissions("collection")

router = APIRouter(
    tags=["Data Collections"],
    prefix="/dataCollections",
)


@router.get("/{collectionId}/tomogram", response_model=Tomogram)
def get_tomogram(collectionId: int = Depends(auth)):
    """Get tomogram that belongs to the collection"""
    return crud.get_tomogram(collectionId)


@router.get("/{collectionId}/motion", response_model=MotionOut)
def get_motion_correction(collectionId: int = Depends(auth), nth: int = None):
    """Get motion correction and tilt alignment data (including drift plot)"""
    return crud.get_motion_correction(collectionId, nth)
