from fastapi import APIRouter, Depends

from ..crud import list as crud
from ..models.api import Unauthorized
from ..models.response import ProposalOut, VisitOut
from ..utils.auth import get_user
from ..utils.database import Paged

router = APIRouter(
    tags=["auth"],
    responses={401: {"model": Unauthorized}},
)


@router.get("/proposals/", response_model=Paged[ProposalOut])
def proposals(
    limit: int = 20,
    page: int = 1,
    s: str = "",
    user=Depends(get_user),
):
    return crud.get_all_proposals(limit, page, s)


@router.get("/visits", response_model=Paged[VisitOut])
def visits(
    limit: int = 20,
    page: int = 1,
    prop: int = None,
    minDate: str = None,
    maxDate: str = None,
    user=Depends(get_user),
):
    return crud.get_all_visits(limit, page, prop, min_date=minDate, max_date=maxDate)


@router.get("/collections")
def collections(
    visit: int,
    limit: int = 20,
    page: int = 1,
    user=Depends(get_user),
):
    return crud.get_all_collections(limit, page, visit)
