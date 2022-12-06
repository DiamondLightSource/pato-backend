from fastapi import APIRouter, Depends

from ..crud import collection as crud
from ..models.response import DataCollectionSummaryOut
from ..utils.auth import User
from ..utils.database import Paged

router = APIRouter(
    tags=["data groups"],
    prefix="/dataGroups",
)


@router.get("/{id}/collections", response_model=Paged[DataCollectionSummaryOut])
def collections(
    id: int,
    limit: int = 100,
    page: int = 1,
    s: str = "",
    user=Depends(User),
):
    """List collections belonging to a data collection group"""
    return crud.get_collections(limit, page, id, s, user)
