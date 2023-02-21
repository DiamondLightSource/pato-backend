from fastapi import APIRouter, Depends

from ..auth import User
from ..crud import groups as crud
from ..models.response import DataCollectionGroupSummaryResponse, DataCollectionSummary
from ..utils.database import Paged
from ..utils.dependencies import pagination

router = APIRouter(
    tags=["Data Collection Groups"],
    prefix="/dataGroups",
)


@router.get("", response_model=Paged[DataCollectionGroupSummaryResponse])
def get_collection_groups(
    session: int = None,
    proposal: str = None,
    page: dict[str, int] = Depends(pagination),
    search: str = "",
    user=Depends(User),
):
    """List collection groups belonging to a session"""
    return crud.get_collection_groups(
        session=session, proposal=proposal, search=search, user=user, **page
    )


@router.get("/{groupId}/dataCollections", response_model=Paged[DataCollectionSummary])
def get_collections(
    groupId: int = None,
    page: dict[str, int] = Depends(pagination),
    search: str = "",
    onlyTomograms: bool = False,
    user=Depends(User),
):
    """List collections belonging to a data collection group"""
    return crud.get_collections(
        groupId=groupId, search=search, user=user, onlyTomograms=onlyTomograms, **page
    )
