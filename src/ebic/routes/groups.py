from fastapi import APIRouter, Depends

from ..auth import User
from ..crud import groups as crud
from ..models.response import DataCollectionSummaryOut
from ..utils.database import Paged
from ..utils.dependencies import pagination

router = APIRouter(
    tags=["Data Collection Groups"],
    prefix="/dataGroups",
)


@router.get("/{groupId}/collections", response_model=Paged[DataCollectionSummaryOut])
def collections(
    groupId: int,
    page: dict[str, int] = Depends(pagination),
    search: str = "",
    user=Depends(User),
):
    """List collections belonging to a data collection group"""
    return crud.get_collections(groupId=groupId, search=search, user=user, **page)
