from fastapi import HTTPException, status
from sqlalchemy import func as f
from sqlalchemy.orm import Query

from ..models.table import (
    CTF,
    BLSession,
    DataCollection,
    MotionCorrection,
    Movie,
    SessionHasPerson,
    TiltImageAlignment,
    Tomogram,
)
from ..utils.auth import AuthUser
from ..utils.database import Paged, db
from ..utils.generic import flatten_join, parse_json_file
from .path import get_tomogram_auto_proc_attachment


def _session_check(query: Query, user: AuthUser, data):
    if bool(set([11, 26]) & set(user.permissions)):
        return data

    if bool(set([8]) & set(user.permissions)):
        query = query.filter(
            BLSession.sessionId == DataCollection.SESSIONID,
            BLSession.beamLineName.like("m__"),
        )
    else:
        query = query.filter(
            SessionHasPerson.sessionId == DataCollection.SESSIONID,
            SessionHasPerson.personId == user.id,
        )

    if query.scalar() is None:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="User not in the parent session",
        )

    return data


def validate_collection(func):
    def wrap(*args, **kwargs):
        user = args[0]
        col_id = args[1]

        data = func(*args, **kwargs)

        if bool(set([11, 26]) & set(user.permissions)):
            return data

        query = db.session.query(DataCollection).filter(
            DataCollection.dataCollectionId == col_id
        )

        return _session_check(query, user, data)

    return wrap


def validate_tomogram(func):
    def wrap(*args, **kwargs):
        user = args[0]
        tomo_id = args[1]

        data = func(*args, **kwargs)

        query = (
            db.session.query(DataCollection)
            .select_from(Tomogram)
            .filter(Tomogram.tomogramId == tomo_id)
            .join(
                DataCollection,
                DataCollection.dataCollectionId == Tomogram.dataCollectionId,
            )
        )

        return _session_check(query, user, data)

    return wrap


@validate_tomogram
def get_motion_correction(user: AuthUser, id, movie: int = None):
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
                    CTF, CTF.motionCorrectionId == MotionCorrection.motionCorrectionId
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


@validate_collection
def get_tomogram(user: AuthUser, id: int) -> Paged[Tomogram]:
    data = db.session.query(Tomogram).filter(Tomogram.dataCollectionId == id).all()

    if not data:
        raise HTTPException(status_code=404, detail="Tomogram not found")

    return Paged(items=data, total=len(data), page=1, limit=100)


@validate_tomogram
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


@validate_tomogram
def get_shift_plot(id: int):
    data = parse_json_file(get_tomogram_auto_proc_attachment(id, "Graph"))

    if not data:
        raise HTTPException(status_code=404, detail="Graph file not found")

    return {"items": data}
