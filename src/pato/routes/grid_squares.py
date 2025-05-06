from fastapi import APIRouter, Depends
from fastapi.responses import FileResponse
from lims_utils.models import Paged, pagination

from ..auth import Permissions
from ..crud import grid_squares as crud
from ..models.response import FoilHole
from ..utils.generic import FoilHoleMetric

router = APIRouter(
    tags=["Grid Squares"],
    prefix="/grid-squares",
)


@router.get("/{gridSquareId}/foil-holes", response_model=Paged[FoilHole])
def get_foil_holes(
    gridSquareId: int = Depends(Permissions.grid_square),
    targetMetric: FoilHoleMetric = "resolution",
    page: dict[str, int] = Depends(pagination),
):
    """Get foil holes in a grid square"""
    return crud.get_foil_holes(grid_square_id=gridSquareId, target=targetMetric, **page)


@router.get("/{gridSquareId}/image", response_class=FileResponse)
def get_grid_square_image(gridSquareId: int = Depends(Permissions.grid_square)):
    """Get image of grid square"""
    return crud.get_grid_square_image(grid_square_id=gridSquareId)
