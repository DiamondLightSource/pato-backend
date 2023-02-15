from typing import Literal

from fastapi import HTTPException, status
from sqlalchemy import and_

from ..models.response import (
    Classification2D,
    CtfImageNumberList,
    FullMovie,
    TomogramResponse,
)
from ..models.table import (
    CTF,
    CryoemInitialModel,
    MotionCorrection,
    Movie,
    ParticleClassification,
    ParticleClassificationGroup,
    ParticlePicker,
    Tomogram,
)
from ..models.table import (
    t_ParticleClassification_has_CryoemInitialModel as ParticleClassificationHasCryoem,
)
from ..utils.database import Paged, db, paginate, unravel
from ..utils.generic import validate_path


def get_tomogram(autoProcId: int) -> TomogramResponse:
    data = (
        db.session.query(Tomogram)
        .filter(Tomogram.autoProcProgramId == autoProcId)
        .scalar()
    )

    if data is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Tomogram not found",
        )

    return data


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


def get_particle_picker(autoProcId: int, filterNull: bool, limit: int, page: int):
    query = (
        db.session.query(
            *unravel(ParticlePicker),
            Movie.createdTimeStamp,
            Movie.movieId,
            MotionCorrection.imageNumber
        )
        .select_from(MotionCorrection)
        .filter_by(autoProcProgramId=autoProcId)
        .join(ParticlePicker, isouter=(not filterNull))
        .join(Movie)
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
) -> Classification2D:
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
        .order_by(_2d_ordering[sortBy].desc())
    )

    return paginate(query, limit, page)


@validate_path
def get_2d_classification_image(classificationId: int) -> str:
    return (
        db.session.query(ParticleClassification.classImageFullPath)
        .filter_by(particleClassificationId=classificationId)
        .scalar()
    )


@validate_path
def get_particle_picker_image(particlePickerId: int) -> str:
    return (
        db.session.query(ParticlePicker.summaryImageFullPath)
        .filter_by(particlePickerId=particlePickerId)
        .scalar()
    )
