from fastapi import APIRouter, Depends

from ..crud import list as crud
from ..models.response import DataCollectionGroupSummaryOut, ProposalOut, VisitOut
from ..utils.auth import User
from ..utils.database import Paged

router = APIRouter(
    tags=["list"],
)


@router.get("/proposals", response_model=Paged[ProposalOut])
def proposals(limit: int = 100, page: int = 1, s: str = "", user=Depends(User)):
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
    user=Depends(User),
):
    """List visits belonging to a proposal"""
    return crud.get_visits(
        limit, page, user, prop, s, min_date=minDate, max_date=maxDate
    )


@router.get(
    "/dataCollectionGroups", response_model=Paged[DataCollectionGroupSummaryOut]
)
def collection_groups(
    visit: int,
    limit: int = 100,
    page: int = 1,
    s: str = "",
    user=Depends(User),
):
    """List collection groups belonging to a visit"""
    return crud.get_collection_groups(limit, page, visit, s, user)
