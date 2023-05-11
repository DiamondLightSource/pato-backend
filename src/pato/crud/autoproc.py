from typing import Literal, Optional

from fastapi import HTTPException, status
from sqlalchemy import Column, and_, select

from ..models.response import (
    Classification,
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
    TiltImageAlignment,
    Tomogram,
)
from ..models.table import (
    t_ParticleClassification_has_CryoemInitialModel as ParticleClassificationHasCryoem,
)
from ..utils.database import Paged, db, paginate, unravel
from ..utils.generic import validate_path


def get_tomogram(autoProcId: int) -> TomogramResponse:
    data = db.session.execute(
        select(*unravel(Tomogram), TiltImageAlignment.refinedTiltAxis)
        .filter(Tomogram.autoProcProgramId == autoProcId)
        .join(TiltImageAlignment)
        .limit(1)
    ).first()

    if data is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Tomogram not found",
        )

    return data.tuple()


def get_motion_correction(limit: int, page: int, autoProcId: int) -> Paged[FullMovie]:
    query = (
        select(MotionCorrection, CTF, Movie)
        .filter(MotionCorrection.autoProcProgramId == autoProcId)
        .join(Movie)
        .join(CTF)
        .order_by(MotionCorrection.imageNumber)
    )

    return paginate(query, limit, page)


def get_ctf(autoProcId: int):
    data = db.session.execute(
        select(
            CTF.estimatedResolution,
            CTF.estimatedDefocus,
            CTF.astigmatism,
            MotionCorrection.imageNumber,
        )
        .filter(MotionCorrection.autoProcProgramId == autoProcId)
        .join(CTF)
        .order_by(MotionCorrection.imageNumber)
    ).all()

    return CtfImageNumberList(items=data)


def get_particle_picker(autoProcId: int, filterNull: bool, limit: int, page: int):
    query = (
        select(
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


_2d_ordering: dict[str, Column] = {
    "class": ParticleClassification.classDistribution,
    "resolution": ParticleClassification.estimatedResolution,
    "particles": ParticleClassification.particlesPerClass,
}


def get_classification(
    autoProcId: int,
    limit: int,
    page: int,
    sortBy: Literal["class", "particles", "resolution"],
    classType: Literal["2d", "3d"],
    filterUnselected: bool,
) -> Classification:
    query = (
        select(
            *unravel(ParticleClassificationGroup),
            *unravel(ParticleClassification),
            *unravel(CryoemInitialModel)
        )
        .filter(
            and_(
                ParticleClassificationGroup.programId == autoProcId,
                ParticleClassificationGroup.type == classType.upper(),
            )
        )
        .join(ParticleClassification, isouter=True)
        .join(ParticleClassificationHasCryoem, isouter=True)
        .join(CryoemInitialModel, isouter=True)
        .order_by(_2d_ordering[sortBy].desc())
    )

    if filterUnselected:
        query = query.filter(ParticleClassification.selected != 0)

    return paginate(query, limit, page)


@validate_path
def get_classification_image(classificationId: int) -> Optional[str]:
    return db.session.scalar(
        select(ParticleClassification.classImageFullPath).filter_by(
            particleClassificationId=classificationId
        )
    )


@validate_path
def get_particle_picker_image(particlePickerId: int) -> Optional[str]:
    return db.session.scalar(
        select(ParticlePicker.summaryImageFullPath).filter_by(
            particlePickerId=particlePickerId
        )
    )
