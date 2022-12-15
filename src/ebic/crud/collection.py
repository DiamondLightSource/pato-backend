from fastapi import HTTPException, status
from sqlalchemy import func as f

from ..models.response import MotionOut
from ..models.table import CTF, MotionCorrection, Movie, Tomogram
from ..utils.database import db
from ..utils.generic import flatten_join, parse_json_file


def get_tomogram(collectionId: int):
    data = (
        db.session.query(Tomogram)
        .filter(Tomogram.dataCollectionId == collectionId)
        .scalar()
    )

    if data is None:
        raise HTTPException(status_code=404, detail="Tomogram not found")

    return data


def get_motion_correction(collectionId: int, movie: int = None):
    if movie is None:
        raw = (
            db.session.query(
                f.count(Movie.movieId).label("total"),
            )
            .filter(Movie.dataCollectionId == collectionId)
            .first()
        )

        if raw.total == 0:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Motion correction data does not exist for data collection",
            )
        movie = raw.total

    query = (
        db.session.query(MotionCorrection, CTF, Movie)
        .filter(Movie.dataCollectionId == collectionId)
        .join(MotionCorrection, MotionCorrection.movieId == Movie.movieId)
        .join(CTF, CTF.motionCorrectionId == MotionCorrection.motionCorrectionId)
        .order_by(MotionCorrection.imageNumber)
        .group_by(Movie.movieId)
    )

    query = query.offset(movie - 1).limit(1).first()

    return MotionOut(
        drift=parse_json_file(query.MotionCorrection.driftPlotFullPath),
        total=query.total,
        **flatten_join(query[:3], ["comments"]),
    )
