from fastapi import APIRouter, Depends
from fastapi.responses import FileResponse

from ..crud import path as crud
from ..utils.auth import Permissions

router = APIRouter(
    tags=["images"], prefix="/image", dependencies=[Depends(Permissions("movie"))]
)


@router.get("/micrograph/{id}", response_class=FileResponse)
def micrograph_snapshot(id: int):
    """Get micrograph snapshot"""
    return crud.get_micrograph_path(id)


@router.get("/fft/{id}", response_class=FileResponse)
def fft_theoretical(id: int):
    """Get FFT theoretical image"""
    return crud.get_fft_path(id)
