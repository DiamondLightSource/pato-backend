from typing import Literal

from fastapi import HTTPException
from sqlalchemy import Column
from sqlalchemy import func as f

from ..models.response import CtfTiltAlignList, FullMovieWithTilt, GenericPlot
from ..models.table import CTF, MotionCorrection, Movie, TiltImageAlignment, Tomogram
from ..utils.database import db, paginate
from ..utils.generic import parse_json_file, validate_path


def _get_generic_tomogram_file(tomogramId: int, column: Column) -> str:
    return (
        db.session.query(f.concat(Tomogram.fileDirectory, "/", column))
        .filter(Tomogram.tomogramId == tomogramId)
        .scalar()
    )


@validate_path
def _get_shift_plot_path(tomogramId: int):
    return _get_generic_tomogram_file(tomogramId, Tomogram.xyShiftPlot)


def get_shift_plot(tomogramId: int):
    data = parse_json_file(_get_shift_plot_path(tomogramId))

    if not data:
        raise HTTPException(status_code=404, detail="Invalid or empty data file")

    return GenericPlot(items=data)


def get_motion_correction(limit: int, page: int, tomogramId: int) -> FullMovieWithTilt:
    query = (
        db.session.query(MotionCorrection, TiltImageAlignment, CTF, Movie)
        .filter(TiltImageAlignment.tomogramId == tomogramId)
        .join(
            MotionCorrection,
            MotionCorrection.movieId == TiltImageAlignment.movieId,
        )
        .join(Movie, Movie.movieId == TiltImageAlignment.movieId)
        .join(CTF, CTF.motionCorrectionId == MotionCorrection.motionCorrectionId)
        .order_by(TiltImageAlignment.refinedTiltAngle)
    )

    motion = dict(paginate(query, limit, page))

    raw_total = (
        db.session.query(
            f.count(Movie.movieId).label("total"),
        )
        .select_from(Tomogram)
        .where(Tomogram.tomogramId == tomogramId)
        .join(Movie, Movie.dataCollectionId == Tomogram.dataCollectionId)
        .scalar()
    )

    return FullMovieWithTilt(**motion, rawTotal=raw_total)


def get_ctf(tomogramId: int):
    data = (
        db.session.query(
            CTF.estimatedResolution,
            CTF.estimatedDefocus,
            CTF.astigmatism,
            TiltImageAlignment.refinedTiltAngle,
        )
        .filter(TiltImageAlignment.tomogramId == tomogramId)
        .join(MotionCorrection, MotionCorrection.movieId == TiltImageAlignment.movieId)
        .join(CTF, CTF.motionCorrectionId == MotionCorrection.motionCorrectionId)
        .order_by(TiltImageAlignment.refinedTiltAngle)
        .all()
    )

    return CtfTiltAlignList(items=data)


@validate_path
def get_slice_path(tomogramId: int) -> str:
    return _get_generic_tomogram_file(tomogramId, Tomogram.centralSliceImage)


@validate_path
def get_movie_path(tomogramId: int) -> str:
    return _get_generic_tomogram_file(tomogramId, Tomogram.tomogramMovie)


@validate_path
def get_projection_path(tomogramId: int, axis: Literal["xy", "xz"]) -> str:
    return _get_generic_tomogram_file(
        tomogramId, Tomogram.projXZ if axis == "xz" else Tomogram.projXY
    )
