from fastapi import APIRouter, Depends

from ..auth import User
from ..crud import proposals, sessions
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
    return proposals.get_proposals(search=search, user=user, **page)


@router.get("/{proposal}/sessions", response_model=Paged[VisitOut])
def get_sessions(
    page: dict[str, int] = Depends(pagination),
    proposal: str = None,
    search: str = "",
    minDate: str = None,
    maxDate: str = None,
    user=Depends(User),
):
    """List visits belonging to a proposal"""
    return sessions.get_sessions(
        user=user,
        proposal=proposal,
        search=search,
        min_date=minDate,
        max_date=maxDate,
        **page
    )
