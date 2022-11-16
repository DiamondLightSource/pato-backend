from fastapi import APIRouter, Depends

from ..crud import tomogram as crud
from ..models.api import Unauthorized
from ..utils.auth import check_admin

router = APIRouter(tags=["tomograph"], responses={401: {"model": Unauthorized}})


@router.get("/tomograms/{collection}")
def tomograms(collection: int, user=Depends(check_admin)):
    """Get list of tomograms that belong to the collection"""
    return crud.get_tomogram(user, collection)


@router.get("/motion/{tomogram}")
def motion(tomogram, nth=None, user=Depends(check_admin)):
    """Get motion correction and tilt alignment data (including drift plot)"""
    return crud.get_motion_correction(user, tomogram, nth)


@router.get("/ctf/{tomogram}")
def ctf(tomogram, user=Depends(check_admin)):
    """Get astigmatism, resolution and defocus as a function of tilt image
    alignment refined tilt angles"""
    return crud.get_ctf(user, tomogram)


@router.get("/shiftPlot/{tomogram}")
def shift_plot(tomogram, user=Depends(check_admin)):
    "Get X-Y shift plot data"
    return crud.get_shift_plot(user, tomogram)
