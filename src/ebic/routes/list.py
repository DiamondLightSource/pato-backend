from fastapi import APIRouter, Depends

from ..crud import list as crud
from ..models.api import Unauthorized
from ..models.response import DataCollectionSummaryOut, ProposalOut, VisitOut
from ..utils.auth import check_admin, get_user
from ..utils.database import Paged

router = APIRouter(
    tags=["list"],
    responses={401: {"model": Unauthorized}},
)


@router.get("/proposals/", response_model=Paged[ProposalOut])
def proposals(limit: int = 100, page: int = 1, s: str = "", user=Depends(check_admin)):
    """List proposals"""
    return crud.get_proposals(limit, page, s, user)


@router.get("/visits", response_model=Paged[VisitOut])
def visits(
    limit: int = 100,
    page: int = 1,
    prop: str = None,
    s: str = "",
    minDate: str = None,
    maxDate: str = None,
    user=Depends(check_admin),
):
    """List visits belonging to a proposal"""
    return crud.get_visits(
        limit, page, user, prop, s, min_date=minDate, max_date=maxDate
    )


@router.get("/collections", response_model=Paged[DataCollectionSummaryOut])
def collections(
    visit: int,
    limit: int = 100,
    page: int = 1,
    user=Depends(get_user),
):
    """List collections belonging to a visit"""
    return crud.get_collections(limit, page, visit)
