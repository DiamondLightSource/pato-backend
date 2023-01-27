from fastapi import HTTPException
from sqlalchemy import and_, case

from ..models.response import FullMovie, ProcessingJobOut
from ..models.table import (
    CTF,
    AutoProcProgram,
    MotionCorrection,
    Movie,
    ProcessingJob,
    Tomogram,
)
from ..utils.database import Paged, db, paginate


def get_tomogram(collectionId: int):
    data = (
        db.session.query(Tomogram)
        .filter(Tomogram.dataCollectionId == collectionId)
        .scalar()
    )

    if data is None:
        raise HTTPException(status_code=404, detail="Tomogram not found")

    return data


def get_motion_correction(limit: int, page: int, collectionId: int) -> Paged[FullMovie]:
    query = (
        db.session.query(MotionCorrection, CTF, Movie)
        .filter(Movie.dataCollectionId == collectionId)
        .join(MotionCorrection, MotionCorrection.movieId == Movie.movieId)
        .join(CTF, CTF.motionCorrectionId == MotionCorrection.motionCorrectionId)
        .order_by(MotionCorrection.imageNumber)
        .group_by(Movie.movieId)
    )

    return paginate(query, limit, page, slow_count=True)


_job_status_description = case(
    [
        (AutoProcProgram.processingJobId == None, "Submitted"),  # noqa: E711
        (AutoProcProgram.processingStatus == 1, "Success"),
        (AutoProcProgram.processingStatus == 0, "Fail"),
        (
            and_(
                AutoProcProgram.processingStatus == None,  # noqa: E711
                AutoProcProgram.processingStartTime != None,  # noqa: E711
            ),
            "Running",
        ),
    ],
    else_="Queued",
)


def get_processing_jobs(
    limit: int,
    page: int,
    collectionId: int,
    search: str,
) -> Paged[ProcessingJobOut]:
    query = (
        db.session.query(
            AutoProcProgram, ProcessingJob, _job_status_description.label("status")
        )
        .select_from(ProcessingJob)
        .join(AutoProcProgram)
    ).filter(ProcessingJob.dataCollectionId == collectionId)

    return paginate(
        query,
        limit,
        page,
    )
