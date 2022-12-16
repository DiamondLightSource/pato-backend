from fastapi import APIRouter, Depends

from ..auth import User
from ..crud import collections as collections
from ..models.response import DataCollectionSummaryOut
from ..utils.database import Paged
from ..utils.dependencies import pagination

router = APIRouter(
    tags=["Data Collection Groups"],
    prefix="/dataGroups",
)


@router.get("/{groupId}/collections", response_model=Paged[DataCollectionSummaryOut])
def get_collections(
    groupId: int,
    page: dict[str, int] = Depends(pagination),
    search: str = "",
    onlyTomograms: bool = False,
    user=Depends(User),
):
    """List collections belonging to a data collection group"""
    return collections.get_collections(
        groupId=groupId, search=search, user=user, onlyTomograms=onlyTomograms, **page
    )
