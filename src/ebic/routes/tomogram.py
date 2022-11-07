from fastapi import APIRouter, Depends
from fastapi.responses import FileResponse

from ..crud import tomogram as crud
from ..models.api import Unauthorized
from ..utils.auth import get_user

router = APIRouter(tags=["auth"], responses={401: {"model": Unauthorized}})


@router.get("/tomograms/{collection}")
def tomograms(collection: int, user=Depends(get_user)):
    """Get list of tomograms that belong to the collection"""
    return crud.get_tomogram(collection)


@router.get("/motion/{tomogram}")
def motion(tomogram, nth=0, user=Depends(get_user)):
    """Get motion correction and tilt alignment data (including drift plot)"""
    return crud.get_motion_correction(tomogram, nth)


@router.get("/thumbnail/micrograph/{movie}", response_class=FileResponse)
def micrograph_snapshot(movie: int, user=Depends(get_user)):
    """Get micrograph snapshot"""
    return crud.get_micrograph_path(movie)


@router.get("/thumbnail/fft/{movie}", response_class=FileResponse)
def fft_theoretical(movie: int, user=Depends(get_user)):
    """Get FFT theoretical image"""
    return crud.get_fft_path(movie)
