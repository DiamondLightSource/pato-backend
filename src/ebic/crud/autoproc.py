from ..models.response import CtfImageNumberList, FullMovie
from ..models.table import CTF, MotionCorrection, Movie
from ..utils.database import Paged, db, paginate


def get_motion_correction(limit: int, page: int, autoProcId: int) -> Paged[FullMovie]:
    query = (
        db.session.query(MotionCorrection, CTF, Movie)
        .filter(MotionCorrection.autoProcProgramId == autoProcId)
        .join(Movie)
        .join(CTF)
        .order_by(MotionCorrection.imageNumber)
    )

    return paginate(query, limit, page)


def get_ctf(autoProcId: int):
    data = (
        db.session.query(
            CTF.estimatedResolution,
            CTF.estimatedDefocus,
            CTF.astigmatism,
            MotionCorrection.imageNumber,
        )
        .filter(MotionCorrection.autoProcProgramId == autoProcId)
        .join(CTF, CTF.motionCorrectionId == MotionCorrection.motionCorrectionId)
        .order_by(MotionCorrection.imageNumber)
        .all()
    )

    return CtfImageNumberList(items=data)
