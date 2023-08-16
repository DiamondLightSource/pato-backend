from fastapi import HTTPException, status
from sqlalchemy import select

from ..models.response import ProcessingJobParameters
from ..models.table import (
    BLSession,
    DataCollection,
    DataCollectionGroup,
    ProcessingJob,
    ProcessingJobParameter,
)
from ..utils.database import db
from ..utils.generic import check_session_active


def get_parameters(processingJob: int) -> ProcessingJobParameters:
    parameters = db.session.execute(
        select(
            ProcessingJobParameter.parameterKey,
            ProcessingJobParameter.parameterValue,
        ).filter(ProcessingJobParameter.processingJobId == processingJob)
    ).all()

    end_date = db.session.scalar(
        select(BLSession.endDate)
        .select_from(ProcessingJob)
        .filter(ProcessingJob.processingJobId == processingJob)
        .join(DataCollection)
        .join(DataCollectionGroup)
        .join(BLSession)
    )

    if len(parameters) < 1 and end_date is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No items found",
        )

    return ProcessingJobParameters(
        items={row.parameterKey: row.parameterValue for row in parameters},
        allowReprocessing=check_session_active(end_date),
    )
