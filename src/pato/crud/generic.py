from typing import Literal

from fastapi import HTTPException, status
from sqlalchemy import Column, and_, case
from sqlalchemy import func as f
from sqlalchemy import literal_column, select

from ..models.response import GenericPlot
from ..models.table import (
    CTF,
    AutoProcProgram,
    DataCollection,
    MotionCorrection,
    Movie,
    ParticlePicker,
    ProcessingJob,
    RelativeIceThickness,
)
from ..utils.database import db


def _generate_buckets(bin: float, minimum: float, column: Column):
    return select(
        f.count(case((column < minimum, 1))).label(f"<{minimum}"),
        *[
            f.count(
                case(
                    (
                        and_(
                            column >= bin * i + minimum,
                            column < bin * (i + 1) + minimum,
                        ),
                        1,
                    )
                )
            ).label(str(bin * i + minimum))
            for i in range(0, 10)
        ],
        f.count(case((column >= bin * 10 + minimum, 1))).label(f">{bin*10+minimum}"),
    )


def _parse_count(query):
    data = db.session.execute(query.order_by(literal_column("1"))).mappings().one()
    if not any([value != 0 for value in data.values()]):
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No items found",
        )

    return GenericPlot(
        items=[{"x": key, "y": value} for (key, value) in dict(data).items()]
    )


def get_ice_histogram(
    parent_type: Literal["autoProc", "dataCollection"],
    parent_id: int,
    dataBin: float,
    minimum: float,
) -> GenericPlot:
    query = _generate_buckets(dataBin, minimum, RelativeIceThickness.median)

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

    return _parse_count(query)


def get_motion(
    parent_type: Literal["autoProc", "dataCollection"],
    parent_id: int,
    dataBin: float,
    minimum: float,
) -> GenericPlot:
    query = _generate_buckets(dataBin, minimum, MotionCorrection.totalMotion)

    if parent_type == "autoProc":
        query = query.filter(MotionCorrection.autoProcProgramId == parent_id)
    else:
        query = (
            query.select_from(DataCollection)
            .filter_by(dataCollectionId=parent_id)
            .join(Movie)
            .join(MotionCorrection)
        )

    return _parse_count(query)


def get_resolution(
    parent_type: Literal["autoProc", "dataCollection"],
    parent_id: int,
    dataBin: float,
    minimum: float,
) -> GenericPlot:
    query = _generate_buckets(dataBin, minimum, CTF.estimatedResolution)

    if parent_type == "autoProc":
        query = query.filter(CTF.autoProcProgramId == parent_id)
    else:
        query = (
            query.select_from(DataCollection)
            .filter_by(dataCollectionId=parent_id)
            .join(Movie)
            .join(MotionCorrection)
            .join(CTF)
        )

    return _parse_count(query)


def get_particle_count(
    parent_type: Literal["autoProc", "dataCollection"],
    parent_id: int,
    dataBin: float,
    minimum: float,
) -> GenericPlot:
    query = _generate_buckets(dataBin, minimum, ParticlePicker.numberOfParticles)

    if parent_type == "autoProc":
        query = query.filter(ParticlePicker.programId == parent_id)
    else:
        query = (
            query.select_from(ProcessingJob)
            .filter_by(dataCollectionId=parent_id)
            .join(AutoProcProgram)
            .join(ParticlePicker)
        )

    return _parse_count(query)
