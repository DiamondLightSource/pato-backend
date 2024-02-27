from typing import Literal

from fastapi import APIRouter, Depends, Query
from fastapi.responses import FileResponse
from lims_utils.models import pagination

from ..auth import Permissions
from ..crud import tomograms as crud
from ..models.response import (
    CtfTiltAlign,
    DataPoint,
    FullMovieWithTilt,
    ItemList,
)

auth = Permissions.tomogram

router = APIRouter(
    tags=["Tomograms"],
    prefix="/tomograms",
)


@router.get("/{tomogramId}/shiftPlot", response_model=ItemList[DataPoint])
def get_shift_plot(tomogramId: int = Depends(auth)):
    """Get X-Y shift plot data"""
    return crud.get_shift_plot(tomogramId)


@router.get("/{tomogramId}/motion", response_model=FullMovieWithTilt)
def get_motion_correction(
    tomogramId: int = Depends(auth),
    page: dict[str, int] = Depends(pagination),
    getMiddle=Query(
        False,
        description="Get index closest to the middle. Limit is set to 1, page is ignored",
    ),
):
    """Get motion correction data for the given tomogram"""
    return crud.get_motion_correction(
        tomogramId=tomogramId, getMiddle=getMiddle, **page
    )


@router.get("/{tomogramId}/centralSlice", response_class=FileResponse)
def get_slice(tomogramId: int = Depends(auth), denoised=False):
    """Get tomogram central slice image"""
    return crud.get_slice_path(tomogramId, denoised)


@router.get("/{tomogramId}/movie", response_class=FileResponse)
def get_movie(tomogramId: int = Depends(auth), denoised=False):
    """Get tomogram movie image"""
    return crud.get_movie_path(tomogramId, denoised)


@router.get("/{tomogramId}/projection", response_class=FileResponse)
def get_projection(axis: Literal["xy", "xz"], tomogramId: int = Depends(auth)):
    """Get tomogram projection image"""
    return crud.get_projection_path(tomogramId=tomogramId, axis=axis)


@router.get("/{tomogramId}/ctf", response_model=ItemList[CtfTiltAlign])
def get_ctf(tomogramId: int = Depends(auth)):
    """Get astigmatism, resolution and defocus as a function of tilt image
    alignment refined tilt angles"""
    return crud.get_ctf(tomogramId)
