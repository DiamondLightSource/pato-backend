import json

from fastapi import HTTPException, status
from sqlalchemy import func as f

from ebic.utils.generic import flatten_join

from ..models.table import CTF, MotionCorrection, Movie, TiltImageAlignment, Tomogram
from ..utils.database import Paged, db


def get_motion_correction(id, movie: int = None):
    raw = dict(
        db.session.query(
            Tomogram.dataCollectionId,
            f.count(Movie.movieId).label("total"),
        )
        .filter(Tomogram.tomogramId == id)
        .join(
            Movie,
            Movie.dataCollectionId == Tomogram.dataCollectionId,
        )
        .first()
    )

    total = (
        db.session.query(f.count(TiltImageAlignment.movieId))
        .filter(TiltImageAlignment.tomogramId == id)
        .first()[0]
    )

    if movie is None:
        movie = raw["total"] - 1 if total == 0 else total - 1

    data = {"total": total, "rawTotal": raw["total"]}

    try:
        if total == 0:
            if raw["total"] == 0:
                raise HTTPException(status_code=404, detail="Tomogram not found")

            data = {
                **data,
                **dict(
                    db.session.query(MotionCorrection)
                    .select_from(Movie)
                    .filter(Movie.dataCollectionId == raw["dataCollectionId"])
                    .join(MotionCorrection, MotionCorrection.movieId == Movie.movieId)
                    .order_by(MotionCorrection.imageNumber)
                    .offset(movie)
                    .limit(1)
                    .first()
                ),
            }
        else:

            data = {
                **data,
                **flatten_join(
                    db.session.query(MotionCorrection, TiltImageAlignment)
                    .filter(TiltImageAlignment.tomogramId == id)
                    .join(
                        MotionCorrection,
                        MotionCorrection.movieId == TiltImageAlignment.movieId,
                    )
                    .order_by(TiltImageAlignment.refinedTiltAngle)
                    .offset(movie)
                    .limit(1)
                    .first()
                ),
            }
    except (TypeError, ValueError):
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Motion correction data does not exist for movie ID",
        )

    try:
        with open("/mnt" + data["driftPlotFullPath"], "r") as file:
            data["drift"] = [
                {"x": i, "y": val}
                for (i, val) in enumerate(json.load(file)["data"][0]["y"])
            ]
    except (FileNotFoundError, KeyError, IndexError, TypeError):
        data["drift"] = []

    return data


def get_tomogram(id: int) -> Paged[Tomogram]:
    data = db.session.query(Tomogram).filter(Tomogram.dataCollectionId == id).all()

    if not data:
        raise HTTPException(status_code=404, detail="Tomogram not found")

    return Paged(items=data, total=len(data), page=1, limit=100)


def get_micrograph_path(id: int) -> str:
    path = (
        db.session.query(MotionCorrection.micrographSnapshotFullPath)
        .filter(MotionCorrection.movieId == id)
        .first()["micrographSnapshotFullPath"]
    )

    if not path:
        raise HTTPException(
            status_code=404,
            detail="No image for this movie or image not found in filesystem",
        )

    return path


def get_fft_path(id: int) -> str:
    path = (
        db.session.query(CTF.fftTheoreticalFullPath)
        .select_from(MotionCorrection)
        .filter(MotionCorrection.movieId == id)
        .join(CTF, CTF.motionCorrectionId == MotionCorrection.motionCorrectionId)
        .first()["fftTheoreticalFullPath"]
    )

    if not path:
        raise HTTPException(
            status_code=404,
            detail="No image for this movie or image not found in filesystem",
        )

    return path
