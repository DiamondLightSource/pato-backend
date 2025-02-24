from lims_utils.tables import FoilHole, GridSquare, Movie
from sqlalchemy import func, select

from ..utils.database import db


def get_foil_holes(grid_square_id: int, page: int, limit: int):

    query = select(
        FoilHole.pixelLocationX,
        FoilHole.pixelLocationY,
        FoilHole.diameter,
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


def get_grid_square_image(grid_square_id: int):
    return db.session.scalar(
        select(GridSquare.gridSquareImage).filter(
            GridSquare.gridSquareId == grid_square_id
        )
    )
