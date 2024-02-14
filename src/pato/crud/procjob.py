from fastapi import HTTPException, status
from lims_utils.tables import ProcessingJobParameter
from sqlalchemy import select

from ..models.response import ProcessingJobParameters
from ..utils.database import db


def get_parameters(processingJob: int) -> ProcessingJobParameters:
    parameters = db.session.execute(
        select(
            ProcessingJobParameter.parameterKey,
            ProcessingJobParameter.parameterValue,
        ).filter(ProcessingJobParameter.processingJobId == processingJob)
    ).all()

    if len(parameters) < 1:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No items found",
        )

    return ProcessingJobParameters(
        items={row.parameterKey: row.parameterValue for row in parameters}
    )
