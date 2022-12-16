from os.path import isfile
from os.path import join as join_path

from fastapi import HTTPException
from sqlalchemy import and_

from ..models.response import GenericPlot
from ..models.table import CTF, AutoProcProgramAttachment, MotionCorrection, Tomogram
from ..utils.database import db
from ..utils.generic import parse_json_file


def validate_path(func):
    def wrap(*args, **kwargs):
        try:
            file = func(*args, **kwargs)
            if not file:
                raise ValueError
        except (ValueError, TypeError):
            raise HTTPException(
                status_code=404,
                detail="No file found in table",
            )

        if not isfile(file):
            raise HTTPException(
                status_code=404,
                detail="File does not exist in filesystem",
            )
        return file

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

    return join_path(paths["filePath"], paths["fileName"])


@validate_path
def get_fft_path(movieId: int) -> str:
    return (
        db.session.query(CTF.fftTheoreticalFullPath)
        .select_from(MotionCorrection)
        .filter(MotionCorrection.movieId == movieId)
        .join(CTF, CTF.motionCorrectionId == MotionCorrection.motionCorrectionId)
        .scalar()
    )


@validate_path
def get_micrograph_path(movieId: int) -> str:
    return (
        db.session.query(MotionCorrection.micrographSnapshotFullPath)
        .filter(MotionCorrection.movieId == movieId)
        .scalar()
    )


@validate_path
def _get_drift_path(movieId: int) -> str:
    return (
        db.session.query(MotionCorrection.driftPlotFullPath)
        .filter(MotionCorrection.movieId == movieId)
        .scalar()
    )


def get_drift(movieId: int) -> GenericPlot:
    return GenericPlot(items=parse_json_file(_get_drift_path(movieId)))
