import os

from fastapi import HTTPException
from sqlalchemy import and_

from ..models.table import CTF, AutoProcProgramAttachment, MotionCorrection, Tomogram
from ..utils.database import db


def validate_path(func):
    def wrap(*args, **kwargs):
        try:
            path = func(*args, **kwargs)
            if not path:
                raise ValueError
        except (ValueError, TypeError):
            raise HTTPException(
                status_code=404,
                detail="No file found in table",
            )

        return "/mnt" + path

    return wrap


@validate_path
def get_tomogram_auto_proc_attachment(id: int, file_type: str = "Result") -> str:
    paths = (
        db.session.query(
            AutoProcProgramAttachment.filePath, AutoProcProgramAttachment.fileName
        )
        .select_from(Tomogram)
        .filter(Tomogram.tomogramId == id)
        .join(
            AutoProcProgramAttachment,
            and_(
                AutoProcProgramAttachment.autoProcProgramId
                == Tomogram.autoProcProgramId,
                AutoProcProgramAttachment.fileType == file_type,
            ),
        )
        .first()
    )

    return os.path.join(paths["filePath"], paths["fileName"])


@validate_path
def get_fft_path(id: int) -> str:
    return (
        db.session.query(CTF.fftTheoreticalFullPath)
        .select_from(MotionCorrection)
        .filter(MotionCorrection.movieId == id)
        .join(CTF, CTF.motionCorrectionId == MotionCorrection.motionCorrectionId)
        .first()["fftTheoreticalFullPath"]
    )


@validate_path
def get_micrograph_path(id: int) -> str:
    return (
        db.session.query(MotionCorrection.micrographSnapshotFullPath)
        .filter(MotionCorrection.movieId == id)
        .first()["micrographSnapshotFullPath"]
    )
