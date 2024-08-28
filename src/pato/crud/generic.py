from typing import Literal

from lims_utils.tables import (
    CTF,
    AutoProcProgram,
    DataCollection,
    MotionCorrection,
    Movie,
    ParticlePicker,
    ProcessingJob,
    RelativeIceThickness,
)
from sqlalchemy import Column, and_, case, select
from sqlalchemy import func as f

from ..models.response import DataPoint, ItemList
from ..utils.generic import parse_count


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
            for i in range(0, 8)
        ],
        f.count(case((column >= bin * 8 + minimum, 1))).label(f">{bin*8+minimum}"),
    )


def get_ice_histogram(
    parent_type: Literal["autoProc", "dataCollection"],
    parent_id: int,
    dataBin: float,
    minimum: float,
) -> ItemList[DataPoint]:
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

    return parse_count(query)


def get_motion(
    parent_type: Literal["autoProc", "dataCollection"],
    parent_id: int,
    dataBin: float,
    minimum: float,
) -> ItemList[DataPoint]:
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

    return parse_count(query)


def get_resolution(
    parent_type: Literal["autoProc", "dataCollection"],
    parent_id: int,
    dataBin: float,
    minimum: float,
) -> ItemList[DataPoint]:
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

    return parse_count(query)


def get_particle_count(
    parent_type: Literal["autoProc", "dataCollection"],
    parent_id: int,
    dataBin: float,
    minimum: float,
) -> ItemList[DataPoint]:
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

    return parse_count(query)
