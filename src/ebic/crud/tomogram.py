from fastapi import HTTPException, status
from sqlalchemy import func as f

from ..models.table import CTF, MotionCorrection, Movie, TiltImageAlignment, Tomogram
from ..utils.database import Paged, db
from ..utils.generic import flatten_join, parse_json_file
from .path import get_tomogram_auto_proc_attachment


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
    else:
        movie = int(movie) - 1

    data = {"total": total, "rawTotal": raw["total"]}

    try:
        if total == 0:
            if raw["total"] == 0:
                raise HTTPException(status_code=404, detail="Tomogram not found")

            query = (
                db.session.query(MotionCorrection, CTF, Movie)
                .filter(Movie.dataCollectionId == raw["dataCollectionId"])
                .join(MotionCorrection, MotionCorrection.movieId == Movie.movieId)
                .join(
                    CTF, CTF.motionCorrectionId == MotionCorrection.MotionCorrectionId
                )
                .order_by(MotionCorrection.imageNumber)
            )
        else:
            query = (
                db.session.query(MotionCorrection, TiltImageAlignment, CTF, Movie)
                .filter(TiltImageAlignment.tomogramId == id)
                .join(
                    MotionCorrection,
                    MotionCorrection.movieId == TiltImageAlignment.movieId,
                )
                .join(Movie, Movie.movieId == TiltImageAlignment.movieId)
                .join(
                    CTF, CTF.motionCorrectionId == MotionCorrection.motionCorrectionId
                )
                .order_by(TiltImageAlignment.refinedTiltAngle)
            )

        query = query.offset(movie).limit(1).first()

    except (TypeError, ValueError):
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Motion correction data does not exist for movie ID",
        )

    data = {
        **data,
        **flatten_join(query, ["comments"]),
    }

    data["drift"] = parse_json_file(data["driftPlotFullPath"])

    return data


def get_tomogram(id: int) -> Paged[Tomogram]:
    data = db.session.query(Tomogram).filter(Tomogram.dataCollectionId == id).all()

    if not data:
        raise HTTPException(status_code=404, detail="Tomogram not found")

    return Paged(items=data, total=len(data), page=1, limit=100)


def get_ctf(id: int):
    data = (
        db.session.query(
            CTF.estimatedResolution,
            CTF.estimatedDefocus,
            CTF.astigmatism,
            TiltImageAlignment.refinedTiltAngle,
        )
        .filter(TiltImageAlignment.tomogramId == id)
        .join(MotionCorrection, MotionCorrection.movieId == TiltImageAlignment.movieId)
        .join(CTF, CTF.motionCorrectionId == MotionCorrection.motionCorrectionId)
        .all()
    )

    return {"items": data}


def get_shift_plot(id: int):
    data = parse_json_file(get_tomogram_auto_proc_attachment(id, "Graph"))

    if not data:
        raise HTTPException(status_code=404, detail="Graph file not found")

    return {"items": data}
