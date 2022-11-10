from fastapi import APIRouter, Depends

from ..crud import tomogram as crud
from ..models.api import Unauthorized
from ..utils.auth import get_user

router = APIRouter(tags=["tomograph"], responses={401: {"model": Unauthorized}})


@router.get("/tomograms/{collection}")
def tomograms(collection: int, user=Depends(get_user)):
    """Get list of tomograms that belong to the collection"""
    return crud.get_tomogram(collection)


@router.get("/motion/{tomogram}")
def motion(tomogram, nth=None, user=Depends(get_user)):
    """Get motion correction and tilt alignment data (including drift plot)"""
    return crud.get_motion_correction(tomogram, nth)


@router.get("/ctf/{tomogram}")
def ctf(tomogram, user=Depends(get_user)):
    """Get astigmatism, resolution and defocus as a function of tilt image
    alignment refined tilt angles"""
    return crud.get_ctf(tomogram)


@router.get("/shiftPlot/{tomogram}")
def shift_plot(tomogram, user=Depends(get_user)):
    "Get X-Y shift plot data"
    return crud.get_shift_plot(tomogram)
