import re
from typing import Literal, Optional

from fastapi import HTTPException, status
from lims_utils.tables import (
    CTF,
    MotionCorrection,
    Movie,
    TiltImageAlignment,
    Tomogram,
)
from sqlalchemy import Column, literal_column, select
from sqlalchemy import func as f

from ..models.response import (
    CtfTiltAlign,
    DataPoint,
    FullMovieWithTilt,
    ItemList,
)
from ..utils.database import db, paginate
from ..utils.generic import parse_json_file, validate_path


@validate_path
def _get_generic_tomogram_file(tomogramId: int, column: Column) -> Optional[str]:
    return db.session.scalar(
        select(f.concat(Tomogram.fileDirectory, "/", column)).filter(
            Tomogram.tomogramId == tomogramId
        )
    )


@validate_path
def _prepend_denoise(base_path: str, image_type: Literal["thumbnail", "movie"]):
    split_file = re.split(f"(_{image_type})", base_path)
    if len(split_file) != 3:
        raise HTTPException(status_code=500, detail="Unexpected filename")

    return split_file[0] + ".denoised" + "".join(split_file[1:3])


@validate_path
def _get_shift_plot_path(tomogramId: int):
    return _get_generic_tomogram_file(tomogramId, Tomogram.xyShiftPlot)


def get_shift_plot(tomogramId: int):
    data = parse_json_file(_get_shift_plot_path(tomogramId))

    if not data:
        raise HTTPException(status_code=404, detail="Invalid or empty data file")

    return ItemList[DataPoint](items=data)


def get_motion_correction(
    limit: int, page: int, tomogramId: int, getMiddle: bool
) -> FullMovieWithTilt:
    if getMiddle:
        total = db.session.scalar(
            select(f.count(literal_column("1")))
            .filter(TiltImageAlignment.tomogramId == tomogramId)
            .order_by(TiltImageAlignment.refinedTiltAngle)
        )

        if not total:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="No items found",
            )

        limit = 1
        page = (total // 2) - 1

    query = (
        select(MotionCorrection, TiltImageAlignment, CTF, Movie)
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

    raw_total = db.session.execute(
        select(
            f.count(Movie.movieId).label("total"),
        )
        .select_from(Tomogram)
        .filter(Tomogram.tomogramId == tomogramId)
        .join(Movie, Movie.dataCollectionId == Tomogram.dataCollectionId)
    ).scalar_one()

    return FullMovieWithTilt(**motion, rawTotal=raw_total)


def get_ctf(tomogramId: int):
    data = db.session.execute(
        select(
            CTF.estimatedResolution,
            CTF.estimatedDefocus,
            CTF.astigmatism,
            TiltImageAlignment.refinedTiltAngle,
        )
        .filter(TiltImageAlignment.tomogramId == tomogramId)
        .join(MotionCorrection, MotionCorrection.movieId == TiltImageAlignment.movieId)
        .join(CTF, CTF.motionCorrectionId == MotionCorrection.motionCorrectionId)
        .order_by(TiltImageAlignment.refinedTiltAngle)
    ).all()

    return ItemList[CtfTiltAlign](items=data)


def get_slice_path(tomogramId: int, denoised: bool):
    base_path = _get_generic_tomogram_file(tomogramId, Tomogram.centralSliceImage)
    return _prepend_denoise(base_path, "thumbnail") if denoised else base_path


def get_movie_path(tomogramId: int, denoised: bool):
    base_path = _get_generic_tomogram_file(tomogramId, Tomogram.tomogramMovie)
    return _prepend_denoise(base_path, "movie") if denoised else base_path


def get_projection_path(tomogramId: int, axis: Literal["xy", "xz"]):
    return _get_generic_tomogram_file(
        tomogramId, Tomogram.projXZ if axis == "xz" else Tomogram.projXY
    )
