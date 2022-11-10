from fastapi import HTTPException
from sqlalchemy import and_

from ..models.table import CTF, AutoProcProgramAttachment, MotionCorrection, Tomogram
from ..utils.database import db


def get_central_slice_path(id: int) -> str:
    path = (
        db.session.query(AutoProcProgramAttachment.filePath)
        .select_from(Tomogram)
        .filter(Tomogram.tomogramId == id)
        .join(
            AutoProcProgramAttachment,
            and_(
                AutoProcProgramAttachment.autoProcProgramId
                == Tomogram.autoProcProgramId,
                AutoProcProgramAttachment.fileType == "Result",
            ),
        )
        .first()["filePath"]
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
