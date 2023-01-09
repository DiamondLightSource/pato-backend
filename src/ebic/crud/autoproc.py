from typing import Literal

from sqlalchemy import and_

from ..models.response import CtfImageNumberList, FullMovie
from ..models.table import (
    CTF,
    CryoemInitialModel,
    MotionCorrection,
    Movie,
    ParticleClassification,
    ParticleClassificationGroup,
    ParticlePicker,
)
from ..models.table import (
    t_ParticleClassification_has_CryoemInitialModel as ParticleClassificationHasCryoem,
)
from ..utils.database import Paged, db, paginate, unravel


def get_motion_correction(limit: int, page: int, autoProcId: int) -> Paged[FullMovie]:
    query = (
        db.session.query(MotionCorrection, CTF, Movie)
        .filter(MotionCorrection.autoProcProgramId == autoProcId)
        .join(Movie)
        .join(CTF)
        .order_by(MotionCorrection.imageNumber)
    )

    return paginate(query, limit, page)


def get_ctf(autoProcId: int):
    data = (
        db.session.query(
            CTF.estimatedResolution,
            CTF.estimatedDefocus,
            CTF.astigmatism,
            MotionCorrection.imageNumber,
        )
        .filter(MotionCorrection.autoProcProgramId == autoProcId)
        .join(CTF)
        .order_by(MotionCorrection.imageNumber)
        .all()
    )

    return CtfImageNumberList(items=data)


def get_particle_picker(autoProcId: int, limit: int, page: int):
    query = (
        db.session.query(ParticlePicker)
        .select_from(MotionCorrection)
        .filter_by(autoProcProgramId=autoProcId)
        .join(ParticlePicker)
        .order_by(MotionCorrection.imageNumber)
    )

    return paginate(query, limit, page)


_2d_ordering = {
    "class": ParticleClassification.classDistribution,
    "resolution": ParticleClassification.estimatedResolution,
    "particles": ParticleClassification.particlesPerClass,
}


def get_2d_classification(
    autoProcId: int,
    limit: int,
    page: int,
    sortBy: Literal["class", "particles", "resolution"],
):
    query = (
        db.session.query(
            *unravel(ParticleClassificationGroup),
            *unravel(ParticleClassification),
            *unravel(CryoemInitialModel)
        )
        .filter(
            and_(
                ParticleClassificationGroup.programId == autoProcId,
                ParticleClassificationGroup.type == "2d",
            )
        )
        .join(ParticleClassification, isouter=True)
        .join(ParticleClassificationHasCryoem, isouter=True)
        .join(CryoemInitialModel, isouter=True)
        .group_by(ParticleClassification)
        .order_by(_2d_ordering[sortBy])
    )

    return paginate(query, limit, page)
