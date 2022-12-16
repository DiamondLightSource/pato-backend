from fastapi import APIRouter, Depends
from fastapi.responses import FileResponse

from ..auth import Permissions
from ..crud import movies, tomograms
from ..models.response import CtfOut, FullMovieWithTilt, GenericPlot
from ..utils.dependencies import pagination

auth = Permissions.tomogram

router = APIRouter(
    tags=["Tomograms"],
    prefix="/tomograms",
)


@router.get("/{tomogramId}/shiftPlot", response_model=GenericPlot)
def get_shift_plot(tomogramId: int = Depends(auth)):
    "Get X-Y shift plot data"
    return tomograms.get_shift_plot(tomogramId)


@router.get("/{tomogramId}/motion", response_model=FullMovieWithTilt)
def get_motion_correction(
    tomogramId: int = Depends(auth), page: dict[str, int] = Depends(pagination)
):
    "Get motion correction data for the given tomogram"
    return tomograms.get_motion_correction(tomogramId=tomogramId, **page)


@router.get("/{tomogramId}/centralSlice", response_class=FileResponse)
def get_slice(tomogramId: int = Depends(auth)):
    """Get tomogram central slice image"""
    return movies.get_tomogram_auto_proc_attachment(tomogramId)


@router.get("/{tomogramId}/ctf", response_model=CtfOut)
def get_ctf(tomogramId: int = Depends(auth)):
    """Get astigmatism, resolution and defocus as a function of tilt image
    alignment refined tilt angles"""
    return tomograms.get_ctf(tomogramId)
