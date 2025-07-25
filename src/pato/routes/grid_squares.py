from fastapi import APIRouter, Depends
from fastapi.responses import FileResponse
from lims_utils.models import Paged, pagination

from ..auth import Permissions
from ..crud import grid_squares as crud
from ..models.response import FoilHole, TomogramResponse

router = APIRouter(
    tags=["Grid Squares"],
    prefix="/grid-squares",
)


@router.get("/{gridSquareId}/foil-holes", response_model=Paged[FoilHole])
def get_foil_holes(
    gridSquareId: int = Depends(Permissions.grid_square),
    page: dict[str, int] = Depends(pagination),
):
    """Get foil holes in a grid square"""
    return crud.get_foil_holes(grid_square_id=gridSquareId, **page)


@router.get("/{gridSquareId}/tomograms", response_model=Paged[TomogramResponse])
def get_tomograms(
    gridSquareId: int = Depends(Permissions.grid_square),
    page: dict[str, int] = Depends(pagination),
):
    """Get tomograms in a search map"""
    return crud.get_tomograms(grid_square_id=gridSquareId, **page)

@router.get("/{gridSquareId}/image", response_class=FileResponse)
def get_grid_square_image(gridSquareId: int = Depends(Permissions.grid_square)):
    """Get image of grid square"""
    return crud.get_grid_square_image(grid_square_id=gridSquareId)
