from fastapi import APIRouter, Depends

from ..crud import collection as crud
from ..models.response import MotionOut, Tomogram
from ..utils.auth import Permissions

router = APIRouter(
    tags=["collection"],
    prefix="/dataCollections",
    dependencies=[Depends(Permissions("collection"))],
)


@router.get("/{id}/tomogram", response_model=Tomogram)
def tomograms(id: int):
    """Get tomogram that belongs to the collection"""
    return crud.get_tomogram(id)


@router.get("/{id}/motion", response_model=MotionOut)
def motion(id: int, nth: int = None):
    """Get motion correction and tilt alignment data (including drift plot)"""
    return crud.get_motion_correction(id, nth)
