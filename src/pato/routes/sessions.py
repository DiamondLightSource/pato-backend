from datetime import datetime

from fastapi import APIRouter, Depends

from ..auth import User
from ..crud import sessions as crud
from ..models.response import VisitOut
from ..utils.database import Paged
from ..utils.dependencies import pagination

router = APIRouter(tags=["Sessions"], prefix="/sessions")


@router.get("", response_model=Paged[VisitOut])
def get_sessions(
    page: dict[str, int] = Depends(pagination),
    proposal: str = None,
    search: str = "",
    minEndDate: datetime = None,
    maxEndDate: datetime = None,
    minStartDate: datetime = None,
    maxStartDate: datetime = None,
    user=Depends(User),
):
    """List visits belonging to a proposal"""
    return crud.get_sessions(
        user=user,
        proposal=proposal,
        search=search,
        minEndDate=minEndDate,
        maxEndDate=maxEndDate,
        minStartDate=minStartDate,
        maxStartDate=maxStartDate,
        **page
    )
