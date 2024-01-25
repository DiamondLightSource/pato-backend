from datetime import datetime
from typing import Optional

from fastapi import APIRouter, Depends
from lims_utils.models import Paged, pagination

from ..auth import User
from ..crud import sessions as crud
from ..models.response import SessionResponse

router = APIRouter(tags=["Sessions"], prefix="/sessions")


@router.get("", response_model=Paged[SessionResponse])
def get_sessions(
    page: dict[str, int] = Depends(pagination),
    proposal: Optional[str] = None,
    search: Optional[str] = None,
    minEndDate: Optional[datetime] = None,
    maxEndDate: Optional[datetime] = None,
    minStartDate: Optional[datetime] = None,
    maxStartDate: Optional[datetime] = None,
    countCollections: bool = False,
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
        countCollections=countCollections,
        **page,
    )
