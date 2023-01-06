from typing import Optional

from fastapi import HTTPException
from sqlalchemy import func as f
from sqlalchemy import or_

from ..auth import User
from ..models.response import DataCollectionSummaryOut, FullMovie, ProcessingJobOut
from ..models.table import (
    CTF,
    AutoProcProgram,
    BLSession,
    DataCollection,
    MotionCorrection,
    Movie,
    ProcessingJob,
    Tomogram,
)
from ..utils.auth import check_session
from ..utils.database import Paged, db, paginate, unravel


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

    return paginate(query, limit, page)


def get_collections(
    limit: int,
    page: int,
    groupId: Optional[int],
    search: str,
    user: User,
    onlyTomograms: bool,
) -> Paged[DataCollectionSummaryOut]:
    query = (
        db.session.query(
            *unravel(DataCollection), f.count(Tomogram.tomogramId).label("tomograms")
        )
        .join(BLSession, BLSession.sessionId == DataCollection.SESSIONID)
        .join(Tomogram, isouter=(not onlyTomograms))
        .filter(
            or_(
                DataCollection.comments.contains(search),
                search == "",
            ),
        )
        .group_by(DataCollection.dataCollectionId)
    )

    if groupId is not None:
        query = query.filter(groupId == DataCollection.dataCollectionGroupId)

    return paginate(
        check_session(query, user),
        limit,
        page,
    )


def get_processing_jobs(
    limit: int,
    page: int,
    collectionId: int,
    search: str,
) -> Paged[ProcessingJobOut]:
    query = (
        db.session.query(AutoProcProgram, ProcessingJob)
        .select_from(ProcessingJob)
        .join(AutoProcProgram)
    ).filter(ProcessingJob.dataCollectionId == collectionId)

    return paginate(
        query,
        limit,
        page,
    )
