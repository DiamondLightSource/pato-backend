from fastapi import APIRouter, Depends

from ..auth import Permissions, User
from ..crud import proposals as crud
from ..crud import sessions as sessions_crud
from ..models.response import ProposalResponse, SessionResponse
from ..utils.database import Paged
from ..utils.dependencies import pagination

router = APIRouter(
    tags=["Proposals"],
    prefix="/proposals",
)


@router.get("", response_model=Paged[ProposalResponse])
def get_proposals(
    page: dict[str, int] = Depends(pagination), search: str = "", user=Depends(User)
):
    """List proposals"""
    return crud.get_proposals(search=search, user=user, **page)


@router.get(
    "/{proposalReference}/sessions/{visitNumber}",
    response_model=SessionResponse,
    tags=["Sessions"],
)
def get_session(proposalReference=Depends(Permissions.session)):
    """Get individual session"""
    return sessions_crud.get_session(proposalReference)
