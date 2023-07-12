from fastapi import HTTPException, status
from sqlalchemy import select

from ..models.table import ProcessingJobParameter
from ..utils.database import db


def get_parameters(processingJob: int) -> dict[str, str]:
    parameters = db.session.execute(
        select(
            ProcessingJobParameter.parameterKey, ProcessingJobParameter.parameterValue
        ).filter(ProcessingJobParameter.processingJobId == processingJob)
    ).all()

    if len(parameters) < 1:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No items found",
        )

    return {row.parameterKey: row.parameterValue for row in parameters}
