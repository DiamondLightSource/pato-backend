from fastapi import APIRouter, Depends
from lims_utils.models import Paged, pagination

from ..auth import Permissions
from ..crud import foil_holes as crud
from ..models.response import Movie

router = APIRouter(
    tags=["Foil Holes"],
    prefix="/foil-holes",
)


@router.get("/{foilHoleId}/movies", response_model=Paged[Movie])
def get_movies(
    foilHoleId: int = Depends(Permissions.foil_hole),
    page: dict[str, int] = Depends(pagination),
):
    """Get movies in a foil hole"""
    return crud.get_movies(foil_hole_id=foilHoleId, **page)
