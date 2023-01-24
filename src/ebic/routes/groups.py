from fastapi import APIRouter, Depends

from ..auth import User
from ..crud import groups as crud
from ..models.response import DataCollectionGroupSummaryOut
from ..utils.database import Paged
from ..utils.dependencies import pagination

router = APIRouter(
    tags=["Data Collection Groups"],
    prefix="/dataGroups",
)


@router.get("", response_model=Paged[DataCollectionGroupSummaryOut])
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
