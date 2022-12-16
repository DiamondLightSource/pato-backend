from fastapi import APIRouter, Depends

from ..auth import User
from ..crud import groups
from ..models.response import DataCollectionGroupSummaryOut
from ..utils.database import Paged
from ..utils.dependencies import pagination

router = APIRouter(tags=["Sessions"], prefix="/sessions")


@router.get(
    "/{sessionId}/dataGroups", response_model=Paged[DataCollectionGroupSummaryOut]
)
def get_collection_groups(
    sessionId: int,
    page: dict[str, int] = Depends(pagination),
    search: str = "",
    user=Depends(User),
):
    """List collection groups belonging to a session"""
    return groups.get_collection_groups(
        sessionId=sessionId, search=search, user=user, **page
    )
