from typing import Optional

from fastapi import APIRouter, Depends
from lims_utils.models import Paged, pagination

from ..auth import User
from ..crud import groups as crud
from ..models.response import DataCollectionGroupSummaryResponse, DataCollectionSummary

router = APIRouter(
    tags=["Data Collection Groups"],
    prefix="/dataGroups",
)


@router.get("", response_model=Paged[DataCollectionGroupSummaryResponse])
def get_collection_groups(
    session: Optional[int] = None,
    proposal: Optional[str] = None,
    page: dict[str, int] = Depends(pagination),
    search: Optional[str] = None,
    user=Depends(User),
):
    """List collection groups belonging to a session"""
    return crud.get_collection_groups(
        session=session, proposal=proposal, search=search, user=user, **page
    )


@router.get("/{groupId}/dataCollections", response_model=Paged[DataCollectionSummary])
def get_collections(
    groupId: Optional[int] = None,
    page: dict[str, int] = Depends(pagination),
    search: Optional[str] = None,
    onlyTomograms: bool = False,
    user=Depends(User),
):
    """List collections belonging to a data collection group"""
    return crud.get_collections(
        groupId=groupId, search=search, user=user, onlyTomograms=onlyTomograms, **page
    )
