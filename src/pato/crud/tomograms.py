import re
from typing import Literal, Optional

from fastapi import HTTPException
from lims_utils.tables import (
    CTF,
    MotionCorrection,
    Movie,
    ProcessedTomogram,
    TiltImageAlignment,
    Tomogram,
)
from sqlalchemy import Column, func, select
from sqlalchemy import func as f

from ..models.response import (
    CtfTiltAlign,
    DataPoint,
    FullMovieWithTilt,
    ItemList,
)
from ..utils.database import db
from ..utils.generic import MovieType, parse_json_file, validate_path


@validate_path
def _get_generic_tomogram_file(tomogramId: int, column: Column) -> Optional[str]:
    return db.session.scalar(
        select(f.concat(Tomogram.fileDirectory, "/", column)).filter(
            Tomogram.tomogramId == tomogramId
        )
    )


def _prepend_denoise(
    base_path: str, image_type: Literal["thumbnail", "movie"], movie_type: MovieType
):
    """Prepend denoised to file extension, to get path to denoised movie file"""
    if movie_type is None:
        return base_path

    split_file = re.split(f"(_{image_type})", base_path)
    if len(split_file) != 3:
        raise HTTPException(status_code=500, detail="Unexpected filename")

    denoised_prefix = ".denoised" if movie_type == "denoised" else f".denoised_{movie_type}"

    return split_file[0] + denoised_prefix + "".join(split_file[1:3])


@validate_path
def _get_movie(tomogramId: int, movie_type: MovieType, image_type: Literal["thumbnail", "movie"]):
    if movie_type:
        # If movie_Type is defined, this means that this is not the standard noisy tomogram we're looking for
        base_path = db.session.scalar(
            select(ProcessedTomogram.filePath).filter(
                ProcessedTomogram.tomogramId == tomogramId,
                ProcessedTomogram.processingType == movie_type.capitalize(),
            )
        )

        if base_path:
            suffix = "_movie.png" if image_type == "movie" else "_thumbnail.jpeg"
            extension = ".cbox" if movie_type == "picked" else ".mrc"
            return base_path.replace(extension, suffix)

        if movie_type == "picked":
            raise HTTPException(status_code=404, detail="No picked tomogram found")

    column = Tomogram.tomogramMovie if image_type == "movie" else Tomogram.centralSliceImage
    base_path = _get_generic_tomogram_file(tomogramId, column)
    return _prepend_denoise(base_path, image_type, movie_type)


@validate_path
def _get_shift_plot_path(tomogramId: int):
    return _get_generic_tomogram_file(tomogramId, Tomogram.xyShiftPlot)


def get_shift_plot(tomogramId: int):
    data = parse_json_file(_get_shift_plot_path(tomogramId))

    if not data:
        raise HTTPException(status_code=404, detail="Invalid or empty data file")

    return ItemList[DataPoint](items=data)


def get_motion_correction(
    limit: int, page: int, data_collection_id: int, getMiddle: bool
) -> FullMovieWithTilt:
    query = (
        select(MotionCorrection, TiltImageAlignment, CTF, Movie)
        .select_from(Movie)
        .filter(Movie.dataCollectionId == data_collection_id)
        .join(
            MotionCorrection,
            MotionCorrection.movieId == Movie.movieId,
        )
        .join(CTF, CTF.motionCorrectionId == MotionCorrection.motionCorrectionId)
        .outerjoin(TiltImageAlignment, TiltImageAlignment.movieId == Movie.movieId)
        .group_by(Movie.movieId)
        # Display movies without alignments last
        .order_by(
            TiltImageAlignment.refinedTiltAngle.is_(None), TiltImageAlignment.refinedTiltAngle, Movie.movieId.desc()
        )
    )

    raw_total = db.session.execute(
        select(
            f.count(Movie.movieId).label("total"),
        ).filter(Movie.dataCollectionId == data_collection_id)
    ).scalar_one()

    aligned_total = db.session.scalar(
        select(f.count(Movie.movieId))
        .select_from(Movie)
        .filter(Movie.dataCollectionId == data_collection_id)
        .join(TiltImageAlignment, TiltImageAlignment.movieId == Movie.movieId)
    )

    if getMiddle:
        # Get central slice, ignore dark images
        page = aligned_total // 2 - 1
        limit = 1

    motion = dict(db.paginate(query, limit, page, precounted_total=raw_total))

    return FullMovieWithTilt(**motion, alignedTotal=aligned_total)


def get_ctf(tomogramId: int):
    data = db.session.execute(
        select(
            func.coalesce(CTF.estimatedResolution, 0).label("estimatedResolution"),
            func.coalesce(CTF.estimatedDefocus, 0).label("estimatedDefocus"),
            func.coalesce(CTF.astigmatism, 0).label("astigmatism"),
            TiltImageAlignment.refinedTiltAngle,
        )
        .filter(TiltImageAlignment.tomogramId == tomogramId)
        .join(MotionCorrection, MotionCorrection.movieId == TiltImageAlignment.movieId)
        .join(CTF, CTF.motionCorrectionId == MotionCorrection.motionCorrectionId)
        .order_by(TiltImageAlignment.refinedTiltAngle)
    ).all()

    return ItemList[CtfTiltAlign](items=data)


def get_slice_path(tomogramId: int, movie_type: MovieType):
    return _get_movie(tomogramId, movie_type, "thumbnail")


def get_movie_path(tomogramId: int, movie_type: MovieType):
    return _get_movie(tomogramId, movie_type, "movie")


def get_projection_path(tomogramId: int, axis: Literal["xy", "xz"]):
    return _get_generic_tomogram_file(tomogramId, Tomogram.projXZ if axis == "xz" else Tomogram.projXY)
