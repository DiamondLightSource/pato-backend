from typing import Literal

from fastapi import HTTPException, status
from sqlalchemy import func as f
from sqlalchemy import literal_column

from ..models.response import GenericPlot
from ..models.table import (
    AutoProcProgram,
    DataCollection,
    ProcessingJob,
    RelativeIceThickness,
)
from ..utils.database import db


def get_ice_histogram_generic(
    parent_type: Literal["autoProc", "dataCollection"], parent_id: int, dataBin: float
) -> GenericPlot:
    query = db.session.query(
        (f.round(RelativeIceThickness.median / dataBin) * dataBin).label("x"),
        f.count(literal_column("1")).label("y"),
    )

    if parent_type == "autoProc":
        query = query.filter(RelativeIceThickness.autoProcProgramId == parent_id)
    else:
        # We could take a shortcut through MotionCorrection, but sometimes it is not
        # mapped to a collection
        query = (
            query.select_from(DataCollection)
            .filter_by(dataCollectionId=parent_id)
            .join(ProcessingJob)
            .join(AutoProcProgram)
            .join(RelativeIceThickness)
        )

    data = query.group_by(literal_column("1")).order_by(literal_column("1")).all()

    if data is None or len(data) == 0:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No items found",
        )

    return GenericPlot(items=data)
