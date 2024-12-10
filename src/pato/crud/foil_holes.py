from lims_utils.tables import Movie
from sqlalchemy import select

from ..utils.database import db


def get_movies(foil_hole_id: int, page: int, limit: int):
    query = select(Movie).filter(Movie.foilHoleId == foil_hole_id)

    return db.paginate(
        query=query, limit=limit, page=page, slow_count=False, scalar=False
    )
