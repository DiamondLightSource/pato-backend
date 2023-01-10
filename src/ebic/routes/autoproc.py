from typing import Literal

from fastapi import APIRouter, Depends
from fastapi.responses import FileResponse

from ..auth import Permissions
from ..crud import autoproc
from ..models.response import (
    Classification2D,
    CtfImageNumberList,
    FullMovie,
    ParticlePicker,
)
from ..utils.database import Paged
from ..utils.dependencies import pagination

auth = Permissions.autoproc_program

router = APIRouter(
    tags=["Auto Processing Programs"],
    prefix="/autoProc",
)


@router.get("/{autoProcId}/motion", response_model=Paged[FullMovie])
def get_motion_correction(
    autoProcId: int = Depends(auth),
    page: dict[str, int] = Depends(pagination),
):
    """Get motion correction and tilt alignment data (including drift plot)"""
    return autoproc.get_motion_correction(autoProcId=autoProcId, **page)


@router.get("/{autoProcId}/ctf", response_model=CtfImageNumberList)
def get_ctf(autoProcId: int = Depends(auth)):
    """Get astigmatism, resolution and defocus as a function of motion correction
    image numbers"""
    return autoproc.get_ctf(autoProcId=autoProcId)


@router.get("/{autoProcId}/particlePicker", response_model=Paged[ParticlePicker])
def get_particle_picker(
    autoProcId: int = Depends(auth),
    filterNull: bool = False,
    page: dict[str, int] = Depends(pagination),
):
    """Get particle picking data"""
    return autoproc.get_particle_picker(
        autoProcId=autoProcId, filterNull=filterNull, **page
    )


@router.get("/{autoProcId}/classification", response_model=Paged[Classification2D])
def get_2d_classification(
    autoProcId: int = Depends(auth),
    sortBy: Literal["class", "particles", "resolution"] = "particles",
    page: dict[str, int] = Depends(pagination),
):
    """Get 2d classification data"""
    return autoproc.get_2d_classification(autoProcId=autoProcId, sortBy=sortBy, **page)


@router.get(
    "/{autoProcId}/classification/{classificationId}/image",
    response_class=FileResponse,
)
def get_2d_classification_image(classificationId: int, autoProcId: int = Depends(auth)):
    """Get class image"""
    return autoproc.get_2d_classification_image(classificationId=classificationId)


@router.get(
    "/{autoProcId}/particlePicker/{particlePickerId}/image",
    response_class=FileResponse,
)
def get_particle_picker_image(particlePickerId: int, autoProcId: int = Depends(auth)):
    """Get class image"""
    return autoproc.get_particle_picker_image(particlePickerId=particlePickerId)
