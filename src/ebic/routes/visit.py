from fastapi import APIRouter, Depends

from ..crud import list as crud
from ..models.response import DataCollectionGroupSummaryOut
from ..utils.auth import User
from ..utils.database import Paged

router = APIRouter(tags=["visits"], prefix="/visits")


@router.get("/{id}/dataGroups", response_model=Paged[DataCollectionGroupSummaryOut])
def collection_groups(
    id: int,
    limit: int = 100,
    page: int = 1,
    s: str = "",
    user=Depends(User),
):
    """List collection groups belonging to a visit"""
    return crud.get_collection_groups(limit, page, id, s, user)
