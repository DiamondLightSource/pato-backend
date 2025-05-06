from lims_utils.tables import (
    CTF,
    FoilHole,
    GridSquare,
    MotionCorrection,
    Movie,
    ParticlePicker,
)
from sqlalchemy import func, select
from sqlalchemy.orm import InstrumentedAttribute
from sqlalchemy.sql.functions import coalesce

from ..utils.database import db
from ..utils.generic import FoilHoleMetric, validate_path

METRIC_TO_COLUMN: dict[FoilHoleMetric, InstrumentedAttribute] = {
    "astigmatism": CTF.astigmatism,
    "defocus": CTF.estimatedDefocus,
    "resolution": CTF.estimatedResolution,
    "particleCount": ParticlePicker.numberOfParticles,
}


def get_foil_holes(grid_square_id: int, page: int, limit: int, target: FoilHoleMetric):
    query = (
        select(
            coalesce(FoilHole.pixelLocationX, 0).label("pixelLocationX"),
            coalesce(FoilHole.pixelLocationY, 0).label("pixelLocationY"),
            coalesce(FoilHole.diameter, 0).label("diameter"),
            FoilHole.foilHoleId,
            func.avg(METRIC_TO_COLUMN[target]).label("val"),
            func.count(Movie.movieId).label("movieCount"),
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
        )
        .group_by(
            FoilHole.foilHoleId,
        )
    )

    if target == "particleCount":
        query = query.join(
            ParticlePicker,
            ParticlePicker.firstMotionCorrectionId
            == MotionCorrection.motionCorrectionId,
            isouter=True,
        )

    return db.paginate(query=query, limit=limit, page=page, slow_count=True)


@validate_path
def get_grid_square_image(grid_square_id: int):
    return db.session.scalar(
        select(GridSquare.gridSquareImage).filter(
            GridSquare.gridSquareId == grid_square_id
        )
    )
