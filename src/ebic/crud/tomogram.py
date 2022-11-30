from fastapi import HTTPException, status
from sqlalchemy import func as f

from ..auth.permission import validate_tomogram
from ..models.response import CtfOut, GenericPlot, TiltAlignmentOut
from ..models.table import CTF, MotionCorrection, Movie, TiltImageAlignment, Tomogram
from ..utils.auth import AuthUser
from ..utils.database import db
from ..utils.generic import flatten_join, parse_json_file
from .path import get_tomogram_auto_proc_attachment


def get_shift_plot(user: AuthUser, id: int):
    data = parse_json_file(get_tomogram_auto_proc_attachment(user, id, "Graph"))

    if not data:
        raise HTTPException(status_code=404, detail="Invalid or empty data file")

    return GenericPlot(items=data)


@validate_tomogram
def get_motion_correction(user: AuthUser, id, movie: int = None):
    raw = (
        db.session.query(
            f.count(Movie.movieId).label("total"),
        )
        .select_from(Tomogram)
        .where(Tomogram.tomogramId == id)
        .join(Movie, Movie.dataCollectionId == Tomogram.dataCollectionId)
        .scalar()
    )

    picked = (
        db.session.query(f.count(TiltImageAlignment.movieId).label("total"))
        .filter(TiltImageAlignment.tomogramId == id)
        .scalar()
    )

    if picked == 0:
        raise HTTPException(status_code=404, detail="Tomogram has no valid movies")

    if movie is None:
        movie = picked

    try:
        query = (
            db.session.query(MotionCorrection, TiltImageAlignment, CTF, Movie)
            .filter(TiltImageAlignment.tomogramId == id)
            .join(
                MotionCorrection,
                MotionCorrection.movieId == TiltImageAlignment.movieId,
            )
            .join(Movie, Movie.movieId == TiltImageAlignment.movieId)
            .join(CTF, CTF.motionCorrectionId == MotionCorrection.motionCorrectionId)
            .order_by(TiltImageAlignment.refinedTiltAngle)
        )

        query = query.offset(movie - 1).limit(1).first()

    except (TypeError, ValueError):
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Motion correction data does not exist for movie index",
        )

    return TiltAlignmentOut(
        drift=parse_json_file(query.MotionCorrection.driftPlotFullPath),
        total=picked,
        rawTotal=raw,
        **flatten_join(query, ["comments"])
    )


@validate_tomogram
def get_ctf(user: AuthUser, id: int):
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

    return CtfOut(items=data)
