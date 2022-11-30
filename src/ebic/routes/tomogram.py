from fastapi import APIRouter, Depends
from fastapi.responses import FileResponse

from ..crud import path, tomogram
from ..models.api import Unauthorized
from ..utils.auth import AuthUser

router = APIRouter(
    tags=["tomograph"], prefix="/tomograms", responses={401: {"model": Unauthorized}}
)


@router.get("/{id}/shiftPlot")
def shift_plot(id, user=Depends(AuthUser)):
    "Get X-Y shift plot data"
    return tomogram.get_shift_plot(user, id)


@router.get("/{id}/motion/")
def motion_correction(id, user=Depends(AuthUser)):
    "Get motion correction data for the given tomogram"
    return tomogram.get_motion_correction(user, id)


@router.get("/{id}/centralSlice", response_class=FileResponse)
def slice(id: int, user=Depends(AuthUser)):
    """Get tomogram central slice image"""
    return path.get_tomogram_auto_proc_attachment(user, id)


@router.get("/{id}/ctf")
def ctf(id, user=Depends(AuthUser)):
    """Get astigmatism, resolution and defocus as a function of tilt image
    alignment refined tilt angles"""
    return tomogram.get_ctf(user, id)
