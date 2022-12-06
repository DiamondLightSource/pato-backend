from fastapi import APIRouter, Depends
from fastapi.responses import FileResponse

from ..crud import path, tomogram
from ..models.response import CtfOut, GenericPlot, TiltAlignmentOut
from ..utils.auth import Permissions

router = APIRouter(
    tags=["tomograph"],
    prefix="/tomograms",
    dependencies=[Depends(Permissions("tomogram"))],
)


@router.get("/{id}/shiftPlot", response_model=GenericPlot)
def shift_plot(id: int):
    "Get X-Y shift plot data"
    return tomogram.get_shift_plot(id)


@router.get("/{id}/motion", response_model=TiltAlignmentOut)
def motion_correction(id: int, nth: int = None):
    "Get motion correction data for the given tomogram"
    return tomogram.get_motion_correction(id, nth)


@router.get("/{id}/centralSlice", response_class=FileResponse)
def slice(id: int):
    """Get tomogram central slice image"""
    return path.get_tomogram_auto_proc_attachment(id)


@router.get("/{id}/ctf", response_model=CtfOut)
def ctf(id: int):
    """Get astigmatism, resolution and defocus as a function of tilt image
    alignment refined tilt angles"""
    return tomogram.get_ctf(id)
