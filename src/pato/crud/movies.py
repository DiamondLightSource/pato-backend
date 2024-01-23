from typing import Optional

from lims_utils.tables import CTF, MotionCorrection, RelativeIceThickness
from sqlalchemy import func as f
from sqlalchemy import select

from ..models.response import GenericPlot, IceThicknessWithAverage
from ..utils.database import db
from ..utils.generic import parse_json_file, validate_path


@validate_path
def get_fft_path(movieId: int) -> Optional[str]:
    return db.session.scalar(
        select(CTF.fftTheoreticalFullPath)
        .select_from(MotionCorrection)
        .filter(MotionCorrection.movieId == movieId)
        .join(CTF, CTF.motionCorrectionId == MotionCorrection.motionCorrectionId)
    )


@validate_path
def get_micrograph_path(movieId: int) -> Optional[str]:
    return db.session.scalar(
        select(MotionCorrection.micrographSnapshotFullPath).filter(
            MotionCorrection.movieId == movieId
        )
    )


@validate_path
def _get_drift_path(movieId: int) -> Optional[str]:
    return db.session.scalar(
        select(MotionCorrection.driftPlotFullPath).filter(
            MotionCorrection.movieId == movieId
        )
    )


def get_drift(movieId: int) -> GenericPlot:
    return GenericPlot(items=parse_json_file(_get_drift_path(movieId)))


def get_relative_ice_thickness(
    movieId: int, getAverages: bool
) -> IceThicknessWithAverage:
    movie_data = db.session.scalar(
        select(RelativeIceThickness)
        .select_from(MotionCorrection)
        .filter_by(movieId=movieId)
        .join(RelativeIceThickness)
    )

    if getAverages:
        averages = db.session.execute(
            select(
                f.round(f.avg(RelativeIceThickness.minimum)).label("minimum"),
                f.round(f.avg(RelativeIceThickness.maximum)).label("maximum"),
                f.round(f.avg(RelativeIceThickness.q3)).label("q3"),
                f.round(f.avg(RelativeIceThickness.q1)).label("q1"),
                f.round(f.avg(RelativeIceThickness.median)).label("median"),
            )
            .select_from(MotionCorrection)
            .filter_by(movieId=movieId)
            .join(
                RelativeIceThickness,
                RelativeIceThickness.autoProcProgramId
                == MotionCorrection.autoProcProgramId,
            )
            .limit(1)
        ).first()

        return IceThicknessWithAverage(avg=averages, current=movie_data)

    return IceThicknessWithAverage(avg=None, current=movie_data)
