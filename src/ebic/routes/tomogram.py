from fastapi import APIRouter, Depends
from fastapi.responses import FileResponse

from ..crud import path, tomogram
from ..models.response import CtfOut, GenericPlot, TiltAlignmentOut
from ..utils.auth import AuthUser

router = APIRouter(
    tags=["tomograph"],
    prefix="/tomograms",
)


@router.get("/{id}/shiftPlot", response_model=GenericPlot)
def shift_plot(id: int, user=Depends(AuthUser)):
    "Get X-Y shift plot data"
    return tomogram.get_shift_plot(user, id)


@router.get("/{id}/motion", response_model=TiltAlignmentOut)
def motion_correction(id: int, nth: int = None, user=Depends(AuthUser)):
    "Get motion correction data for the given tomogram"
    return tomogram.get_motion_correction(user, id, nth)


@router.get("/{id}/centralSlice", response_class=FileResponse)
def slice(id: int, user=Depends(AuthUser)):
    """Get tomogram central slice image"""
    return path.get_tomogram_auto_proc_attachment(user, id)


@router.get("/{id}/ctf", response_model=CtfOut)
def ctf(id: int, user=Depends(AuthUser)):
    """Get astigmatism, resolution and defocus as a function of tilt image
    alignment refined tilt angles"""
    return tomogram.get_ctf(user, id)
