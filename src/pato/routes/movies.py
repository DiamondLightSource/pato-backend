from fastapi import APIRouter, Depends
from fastapi.responses import FileResponse

from ..auth import Permissions
from ..crud import movies as crud
from ..models.response import DataPoint, IceThicknessWithAverage, ItemList

auth = Permissions.movie

router = APIRouter(tags=["Movies"], prefix="/movies")


@router.get("/{movieId}/micrograph", response_class=FileResponse)
def get_micrograph(movieId: int = Depends(auth)):
    """Get micrograph snapshot"""
    return crud.get_micrograph_path(movieId)


@router.get("/{movieId}/fft", response_class=FileResponse)
def get_fft(movieId: int = Depends(auth)):
    """Get FFT theoretical image"""
    return crud.get_fft_path(movieId)


@router.get("/{movieId}/drift", response_model=ItemList[DataPoint])
def get_drift(movieId: int = Depends(auth)):
    """Get drift from a JSON file or from the drift table"""
    return crud.get_drift(movieId=movieId)


@router.get("/{movieId}/iceThickness", response_model=IceThicknessWithAverage)
def get_relative_ice_thickness(movieId: int = Depends(auth), getAverages: bool = False):
    """Get values for relative ice thickness for a given movie"""
    return crud.get_relative_ice_thickness(movieId=movieId, getAverages=getAverages)
