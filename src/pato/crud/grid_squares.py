from lims_utils.tables import FoilHole, GridSquare, Movie
from sqlalchemy import func, select
from sqlalchemy.sql.functions import coalesce

from ..utils.database import db
from ..utils.generic import validate_path


def get_foil_holes(grid_square_id: int, page: int, limit: int):
    query = select(
        coalesce(FoilHole.pixelLocationX, 0).label("pixelLocationX"),
        coalesce(FoilHole.pixelLocationY, 0).label("pixelLocationY"),
        coalesce(FoilHole.diameter, 0).label("diameter"),
        FoilHole.foilHoleId,
        func.count(Movie.movieId).label("movieCount"),
    ).filter(
        FoilHole.gridSquareId == grid_square_id,
    ).join(
        Movie, Movie.foilHoleId == FoilHole.foilHoleId, isouter=True
    ).group_by(
        FoilHole.foilHoleId,
    )

    return db.paginate(query=query, limit=limit, page=page, slow_count=True)

@validate_path
def get_grid_square_image(grid_square_id: int):
    return db.session.scalar(
        select(GridSquare.gridSquareImage).filter(
            GridSquare.gridSquareId == grid_square_id
        )
    )
