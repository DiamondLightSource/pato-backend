from fastapi import APIRouter, Depends
from fastapi.responses import FileResponse

from ..crud import tomogram as crud
from ..models.api import Unauthorized
from ..utils.auth import get_user

router = APIRouter(tags=["auth"], responses={401: {"model": Unauthorized}})


@router.get("/tomograms/{collection}")
def tomograms(collection: int, user=Depends(get_user)):
    return crud.get_tomogram(collection)


@router.get("/motion/{tomogram}")
def motion(tomogram, nth=0, user=Depends(get_user)):
    return crud.get_motion_correction(tomogram, nth)


@router.get("/thumbnail/micrograph/{id}", response_class=FileResponse)
def micrograph(id, user=Depends(get_user)):
    return crud.get_micrograph_path(id)
