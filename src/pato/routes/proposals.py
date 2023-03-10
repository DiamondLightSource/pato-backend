from fastapi import APIRouter, Depends

from ..auth import User
from ..crud import proposals as crud
from ..models.response import ProposalResponse
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
