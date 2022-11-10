from fastapi import APIRouter, Depends
from fastapi.responses import FileResponse

from ..crud import image as crud
from ..models.api import Unauthorized
from ..utils.auth import get_user

router = APIRouter(
    tags=["images"], prefix="/image", responses={401: {"model": Unauthorized}}
)


@router.get("/micrograph/{movie}", response_class=FileResponse)
def micrograph_snapshot(movie: int, user=Depends(get_user)):
    """Get micrograph snapshot"""
    return crud.get_micrograph_path(movie)


@router.get("/fft/{movie}", response_class=FileResponse)
def fft_theoretical(movie: int, user=Depends(get_user)):
    """Get FFT theoretical image"""
    return crud.get_fft_path(movie)


@router.get("/slice/{tomogram}", response_class=FileResponse)
def slice(tomogram: int, user=Depends(get_user)):
    """Get tomogram central slice image"""
    return crud.get_central_slice_path(tomogram)
