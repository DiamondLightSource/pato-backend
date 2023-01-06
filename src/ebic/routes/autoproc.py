from fastapi import APIRouter, Depends

from ..auth import Permissions
from ..crud import autoproc
from ..models.response import CtfImageNumberList, FullMovie
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
    return autoproc.get_ctf(autoProcId)
