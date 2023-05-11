from typing import Literal

from fastapi import APIRouter, Depends
from fastapi.responses import FileResponse

from ..auth import Permissions
from ..crud import autoproc as crud
from ..crud import generic
from ..models.response import (
    Classification,
    CtfImageNumberList,
    FullMovie,
    ParticlePicker,
    TomogramResponse,
)
from ..utils.database import Paged
from ..utils.dependencies import pagination

auth = Permissions.autoproc_program

router = APIRouter(
    tags=["Auto Processing Programs"],
    prefix="/autoProc",
)


@router.get("/{autoProcId}/tomogram", response_model=TomogramResponse)
def get_tomogram(
    autoProcId: int = Depends(auth),
):
    """Get tomogram"""
    return crud.get_tomogram(autoProcId=autoProcId)


@router.get("/{autoProcId}/motion", response_model=Paged[FullMovie])
def get_motion_correction(
    autoProcId: int = Depends(auth),
    page: dict[str, int] = Depends(pagination),
):
    """Get motion correction and tilt alignment data (including drift plot)"""
    return crud.get_motion_correction(autoProcId=autoProcId, **page)


@router.get("/{autoProcId}/ctf", response_model=CtfImageNumberList)
def get_ctf(autoProcId: int = Depends(auth)):
    """Get astigmatism, resolution and defocus as a function of motion correction
    image numbers"""
    return crud.get_ctf(autoProcId=autoProcId)


@router.get("/{autoProcId}/particlePicker", response_model=Paged[ParticlePicker])
def get_particle_picker(
    autoProcId: int = Depends(auth),
    filterNull: bool = False,
    page: dict[str, int] = Depends(pagination),
):
    """Get particle picking data"""
    return crud.get_particle_picker(
        autoProcId=autoProcId, filterNull=filterNull, **page
    )


@router.get("/{autoProcId}/classification", response_model=Paged[Classification])
def get_classification(
    autoProcId: int = Depends(auth),
    sortBy: Literal["class", "particles", "resolution"] = "particles",
    classType: Literal["2d", "3d"] = "2d",
    filterUnselected: bool = False,
    page: dict[str, int] = Depends(pagination),
):
    """Get classification data"""
    return crud.get_classification(
        autoProcId=autoProcId,
        sortBy=sortBy,
        classType=classType,
        filterUnselected=filterUnselected,
        **page
    )


@router.get(
    "/{autoProcId}/classification/{classificationId}/image",
    response_class=FileResponse,
)
def get_classification_image(classificationId: int, autoProcId: int = Depends(auth)):
    """Get class' image representation or MRC file"""
    return crud.get_classification_image(classificationId=classificationId)


@router.get(
    "/{autoProcId}/particlePicker/{particlePickerId}/image",
    response_class=FileResponse,
)
def get_particle_picker_image(particlePickerId: int, autoProcId: int = Depends(auth)):
    """Get class image"""
    return crud.get_particle_picker_image(particlePickerId=particlePickerId)


@router.get(
    "/{autoProcId}/iceThickness",
)
def get_ice_histogram(
    dataBin: float = 10000, minimum: float = 0, autoProcId: int = Depends(auth)
):
    """Get relative ice thickness histogram"""
    return generic.get_ice_histogram(
        parent_type="autoProc", parent_id=autoProcId, minimum=minimum, dataBin=dataBin
    )


@router.get(
    "/{autoProcId}/totalMotion",
)
def get_motion(
    dataBin: float = 50, minimum: float = 0, autoProcId: int = Depends(auth)
):
    """Get total motion histogram"""
    return generic.get_motion(
        parent_type="autoProc", parent_id=autoProcId, minimum=minimum, dataBin=dataBin
    )


@router.get(
    "/{autoProcId}/resolution",
)
def get_resolution(
    dataBin: float = 1, minimum: float = 0, autoProcId: int = Depends(auth)
):
    """Get estimated resolution histogram"""
    return generic.get_resolution(
        parent_type="autoProc", parent_id=autoProcId, minimum=minimum, dataBin=dataBin
    )


@router.get(
    "/{autoProcId}/particles",
)
def get_particle_count(
    dataBin: float = 1, minimum: float = 0, autoProcId: int = Depends(auth)
):
    """Get particle count histogram"""
    return generic.get_particle_count(
        parent_type="autoProc", parent_id=autoProcId, minimum=minimum, dataBin=dataBin
    )
