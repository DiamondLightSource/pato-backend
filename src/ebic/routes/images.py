from fastapi import APIRouter, Depends
from fastapi.responses import FileResponse

from ..auth import Permissions
from ..crud import path as crud

auth = Permissions("movie")

router = APIRouter(tags=["Images"], prefix="/image")


@router.get("/micrograph/{movieId}", response_class=FileResponse)
def get_micrograph(movieId: int = Depends(auth)):
    """Get micrograph snapshot"""
    return crud.get_micrograph_path(movieId)


@router.get("/fft/{movieId}", response_class=FileResponse)
def get_fft(movieId: int = Depends(auth)):
    """Get FFT theoretical image"""
    return crud.get_fft_path(movieId)
