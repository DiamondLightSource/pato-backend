from fastapi import APIRouter, Depends

from ..crud import list as crud
from ..models.response import ProposalOut, VisitOut
from ..utils.auth import User
from ..utils.database import Paged

router = APIRouter(
    tags=["proposals"],
    prefix="/proposals",
)


@router.get("", response_model=Paged[ProposalOut])
def proposals(limit: int = 100, page: int = 1, s: str = "", user=Depends(User)):
    """List proposals"""
    return crud.get_proposals(limit, page, s, user)


@router.get("/{id}/visits", response_model=Paged[VisitOut])
def visits(
    limit: int = 100,
    page: int = 1,
    id: str = None,
    s: str = "",
    minDate: str = None,
    maxDate: str = None,
    user=Depends(User),
):
    """List visits belonging to a proposal"""
    return crud.get_visits(limit, page, user, id, s, min_date=minDate, max_date=maxDate)
