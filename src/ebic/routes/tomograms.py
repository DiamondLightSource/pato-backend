from fastapi import APIRouter, Depends
from fastapi.responses import FileResponse

from ..auth import Permissions
from ..crud import path, tomograms
from ..models.response import CtfOut, GenericPlot, TiltAlignmentOut

auth = Permissions("tomogram")

router = APIRouter(
    tags=["Tomograms"],
    prefix="/tomograms",
)


@router.get("/{tomogramId}/shiftPlot", response_model=GenericPlot)
def get_shift_plot(tomogramId: int = Depends(auth)):
    "Get X-Y shift plot data"
    return tomograms.get_shift_plot(tomogramId)


@router.get("/{tomogramId}/motion", response_model=TiltAlignmentOut)
def get_motion_correction(tomogramId: int = Depends(auth), nth: int = None):
    "Get motion correction data for the given tomogram"
    return tomograms.get_motion_correction(tomogramId, nth)


@router.get("/{tomogramId}/centralSlice", response_class=FileResponse)
def get_slice(tomogramId: int = Depends(auth)):
    """Get tomogram central slice image"""
    return path.get_tomogram_auto_proc_attachment(tomogramId)


@router.get("/{tomogramId}/ctf", response_model=CtfOut)
def get_ctf(tomogramId: int = Depends(auth)):
    """Get astigmatism, resolution and defocus as a function of tilt image
    alignment refined tilt angles"""
    return tomograms.get_ctf(tomogramId)
