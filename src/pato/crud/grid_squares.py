from lims_utils.tables import (
    CTF,
    FoilHole,
    GridSquare,
    MotionCorrection,
    Movie,
    ParticlePicker,
)
from sqlalchemy import distinct, func, select
from sqlalchemy.sql.functions import coalesce

from ..utils.database import db
from ..utils.generic import validate_path


def get_foil_holes(grid_square_id: int, page: int, limit: int):
    query = (
        select(
            coalesce(FoilHole.pixelLocationX, 0).label("pixelLocationX"),
            coalesce(FoilHole.pixelLocationY, 0).label("pixelLocationY"),
            coalesce(FoilHole.diameter, 0).label("diameter"),
            FoilHole.foilHoleId,
            # Astigmatism can be negative if short/long axis get mixed up when calculating
            # astigmatism from defocus
            func.abs(func.avg(CTF.astigmatism)).label("astigmatism"),
            func.avg(CTF.estimatedResolution).label("resolution"),
            func.avg(ParticlePicker.numberOfParticles).label("particleCount"),
            func.count(distinct(Movie.movieId)).label("movieCount"),
        )
        .filter(FoilHole.gridSquareId == grid_square_id)
        .join(Movie, Movie.foilHoleId == FoilHole.foilHoleId, isouter=True)
        .join(
            MotionCorrection,
            MotionCorrection.movieId == Movie.movieId,
            isouter=True,
        )
        .join(
            CTF,
            CTF.motionCorrectionId == MotionCorrection.motionCorrectionId,
            isouter=True,
        ).join(
            ParticlePicker,
            ParticlePicker.firstMotionCorrectionId
            == MotionCorrection.motionCorrectionId,
            isouter=True,
        ).group_by(
            FoilHole.foilHoleId
        )
    )

    return db.paginate(query=query, limit=limit, page=page, slow_count=True)


@validate_path
def get_grid_square_image(grid_square_id: int):
    return db.session.scalar(
        select(GridSquare.gridSquareImage).filter(
            GridSquare.gridSquareId == grid_square_id
        )
    )
