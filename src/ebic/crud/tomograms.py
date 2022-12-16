from fastapi import HTTPException
from sqlalchemy import func as f

from ..models.response import CtfOut, FullMovieWithTilt, GenericPlot
from ..models.table import CTF, MotionCorrection, Movie, TiltImageAlignment, Tomogram
from ..utils.database import db, paginate
from ..utils.generic import parse_json_file
from .movies import get_tomogram_auto_proc_attachment


def get_shift_plot(id: int):
    data = parse_json_file(get_tomogram_auto_proc_attachment(id, "Graph"))

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

    return CtfOut(items=data)
