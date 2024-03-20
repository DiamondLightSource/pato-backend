import os
from typing import Literal, Optional

from fastapi import HTTPException, status
from lims_utils.models import Paged
from lims_utils.tables import (
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
from lims_utils.tables import (
    t_ParticleClassification_has_CryoemInitialModel as ParticleClassificationHasCryoem,
)
from sqlalchemy import UnaryExpression, and_, or_, select

from ..models.response import (
    Classification,
    CtfBaseSpa,
    FullMovie,
    ItemList,
    TomogramResponse,
)
from ..utils.database import db, paginate, unravel
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

    return data._tuple()


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
            ParticlePicker.numberOfParticles,
            MotionCorrection.imageNumber,
        )
        .filter(MotionCorrection.autoProcProgramId == autoProcId)
        .join(CTF)
        .join(ParticlePicker)
        .order_by(MotionCorrection.imageNumber)
    ).all()

    return ItemList[CtfBaseSpa](items=data)


def get_particle_picker(autoProcId: int, filterNull: bool, limit: int, page: int):
    query = (
        select(
            *unravel(ParticlePicker),
            Movie.createdTimeStamp,
            Movie.movieId,
            MotionCorrection.imageNumber,
        )
        .select_from(MotionCorrection)
        .filter_by(autoProcProgramId=autoProcId)
        .join(ParticlePicker, isouter=(not filterNull))
        .join(Movie)
        .order_by(MotionCorrection.imageNumber)
    )

    return paginate(query, limit, page)


_2d_ordering: dict[str, UnaryExpression] = {
    "class": ParticleClassification.classDistribution.desc(),
    "resolution": ParticleClassification.estimatedResolution.asc(),
    "particles": ParticleClassification.particlesPerClass.desc(),
}


def get_classification(
    autoProcId: int,
    limit: int,
    page: int,
    sortBy: Literal["class", "particles", "resolution"],
    classType: Literal["2d", "3d"],
    excludeUnselected: bool,
) -> Paged[Classification]:
    query = (
        select(
            *unravel(ParticleClassificationGroup),
            *unravel(ParticleClassification),
            *unravel(CryoemInitialModel),
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
    )

    if sortBy == "resolution":
        query = query.order_by(
            # Instead of null, the default value for estimated resolutions is 0.
            # I do not know if this will change, hence, check both.
            or_(
                ParticleClassification.estimatedResolution == 0,
                ParticleClassification.estimatedResolution.is_(None),
            ),
            ParticleClassification.estimatedResolution.asc(),
        )
    else:
        query = query.order_by(_2d_ordering[sortBy])

    if excludeUnselected:
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
def get_angle_distribution(classificationId: int) -> Optional[str]:
    path = db.session.scalar(
        select(ParticleClassification.classImageFullPath).filter_by(
            particleClassificationId=classificationId
        )
    )

    return os.path.splitext(path)[0] + "_angdist.jpeg"


@validate_path
def get_particle_picker_image(particlePickerId: int) -> Optional[str]:
    return db.session.scalar(
        select(ParticlePicker.summaryImageFullPath).filter_by(
            particlePickerId=particlePickerId
        )
    )
