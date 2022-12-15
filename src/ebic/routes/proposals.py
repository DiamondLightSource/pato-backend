from fastapi import APIRouter, Depends

from ..auth import User
from ..crud import proposals as crud
from ..models.response import ProposalOut, VisitOut
from ..utils.database import Paged
from ..utils.dependencies import pagination

router = APIRouter(
    tags=["Proposals"],
    prefix="/proposals",
)


@router.get("", response_model=Paged[ProposalOut])
def get_proposals(
    page: dict[str, int] = Depends(pagination), search: str = "", user=Depends(User)
):
    """List proposals"""
    return crud.get_proposals(search=search, user=user, **page)


@router.get("/{proposal}/visits", response_model=Paged[VisitOut])
def get_visits(
    page: dict[str, int] = Depends(pagination),
    proposal: str = None,
    search: str = "",
    minDate: str = None,
    maxDate: str = None,
    user=Depends(User),
):
    """List visits belonging to a proposal"""
    return crud.get_visits(
        user=user,
        proposal=proposal,
        search=search,
        min_date=minDate,
        max_date=maxDate,
        **page
    )
