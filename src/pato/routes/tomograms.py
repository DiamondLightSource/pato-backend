from typing import Literal

from fastapi import APIRouter, Depends
from fastapi.responses import FileResponse

from ..auth import Permissions
from ..crud import tomograms as crud
from ..models.response import CtfTiltAlign, DataPoint, FeatureList, FeatureType, ItemList
from ..utils.generic import MovieType

auth = Permissions.tomogram

router = APIRouter(
    tags=["Tomograms"],
    prefix="/tomograms",
)


@router.get("/{tomogramId}/shiftPlot", response_model=ItemList[DataPoint])
def get_shift_plot(tomogramId: int = Depends(auth)):
    """Get X-Y shift plot data"""
    return crud.get_shift_plot(tomogramId)


@router.get("/{tomogramId}/centralSlice", response_class=FileResponse)
def get_slice(tomogramId: int = Depends(auth), movieType: MovieType = None):
    """Get tomogram central slice image"""
    return crud.get_slice_path(tomogramId, movieType)


@router.get("/{tomogramId}/movie", response_class=FileResponse)
def get_movie(tomogramId: int = Depends(auth), movieType: MovieType = None):
    """Get tomogram movie image"""
    return crud.get_movie_path(tomogramId, movieType)

@router.get("/{tomogramId}/features/{feature}", response_class=FileResponse)
def get_feature(feature: FeatureType, tomogramId: int = Depends(auth)):
    """Get tomogram feature"""
    return crud.get_feature(tomogramId, feature)

@router.get("/{tomogramId}/features", response_model=FeatureList)
def get_features(tomogramId: int = Depends(auth)):
    """Get tomogram features"""
    # Avoids prematurely converting to enum, which would fail validation
    return FeatureList(features=crud.get_features(tomogramId))

@router.get("/{tomogramId}/projection", response_class=FileResponse)
def get_projection(axis: Literal["xy", "xz"], tomogramId: int = Depends(auth)):
    """Get tomogram projection image"""
    return crud.get_projection_path(tomogramId=tomogramId, axis=axis)


@router.get("/{tomogramId}/ctf", response_model=ItemList[CtfTiltAlign])
def get_ctf(tomogramId: int = Depends(auth)):
    """Get astigmatism, resolution and defocus as a function of tilt image
    alignment refined tilt angles"""
    return crud.get_ctf(tomogramId)
