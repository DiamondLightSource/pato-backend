from fastapi import APIRouter, Depends
from fastapi.responses import FileResponse

from ..crud import path as crud
from ..models.api import Unauthorized
from ..utils.auth import AuthUser

router = APIRouter(
    tags=["images"], prefix="/image", responses={401: {"model": Unauthorized}}
)


@router.get("/micrograph/{movie}", response_class=FileResponse)
def micrograph_snapshot(movie: int, user=Depends(AuthUser)):
    """Get micrograph snapshot"""
    return crud.get_micrograph_path(user, movie)


@router.get("/fft/{movie}", response_class=FileResponse)
def fft_theoretical(movie: int, user=Depends(AuthUser)):
    """Get FFT theoretical image"""
    return crud.get_fft_path(user, movie)


@router.get("/slice/{tomogram}", response_class=FileResponse)
def slice(tomogram: int, user=Depends(AuthUser)):
    """Get tomogram central slice image"""
    return crud.get_tomogram_auto_proc_attachment(user, tomogram)
