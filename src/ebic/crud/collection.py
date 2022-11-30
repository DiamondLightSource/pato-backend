from operator import or_

from fastapi import HTTPException, status
from sqlalchemy import and_
from sqlalchemy import func as f
from sqlalchemy.orm import Query

from ..auth.permission import validate_collection
from ..crud.list import check_admin
from ..models.response import DataCollectionSummaryOut, MotionOut
from ..models.table import (
    CTF,
    BLSession,
    DataCollection,
    MotionCorrection,
    Movie,
    SessionHasPerson,
    Tomogram,
)
from ..utils.auth import AuthUser, is_em_staff
from ..utils.database import Paged, db, paginate
from ..utils.generic import flatten_join, parse_json_file


@check_admin
def _concat_collection_user(user: AuthUser, query: Query):
    if is_em_staff(user.permissions):
        return query.join(
            BLSession, BLSession.sessionId == DataCollection.SESSIONID
        ).filter(BLSession.beamLineName.like("m__"))

    return query.filter(
        SessionHasPerson.sessionId == DataCollection.SESSIONID,
        SessionHasPerson.personId == user.id,
    )


def get_collections(
    items: int, page: int, id: int, search: str, user: AuthUser
) -> Paged[DataCollectionSummaryOut]:
    query = db.session.query(
        *[c for c in DataCollection.__table__.columns],
        f.count(DataCollection.dataCollectionId).over().label("total"),
    ).where(
        and_(
            id == DataCollection.dataCollectionGroupId,
            or_(
                DataCollection.comments.contains(search),
                search == "",
            ),
        )
    )

    return paginate(_concat_collection_user(user, query), items, page)


@validate_collection
def get_tomogram(user: AuthUser, id: int) -> Tomogram:
    data = db.session.query(Tomogram).filter(Tomogram.dataCollectionId == id).scalar()

    if data is None:
        raise HTTPException(status_code=404, detail="Tomogram not found")

    return data


@validate_collection
def get_motion_correction(user: AuthUser, id, movie: int = None) -> MotionOut:
    if movie is None:
        raw = (
            db.session.query(
                f.count(Movie.movieId).label("total"),
            )
            .filter(Movie.dataCollectionId == id)
            .first()
        )

        if raw.total == 0:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Motion correction data does not exist for data collection",
            )
        movie = raw.total

    query = (
        db.session.query(
            MotionCorrection, CTF, Movie, f.count(Movie.movieId).over().label("total")
        )
        .filter(Movie.dataCollectionId == id)
        .join(MotionCorrection, MotionCorrection.movieId == Movie.movieId)
        .join(CTF, CTF.motionCorrectionId == MotionCorrection.motionCorrectionId)
        .order_by(MotionCorrection.imageNumber)
        .group_by(Movie.movieId)
    )

    query = query.offset(movie - 1).limit(1).first()

    return MotionOut(
        drift=parse_json_file(query.MotionCorrection.driftPlotFullPath),
        total=query.total,
        **flatten_join(query[:3], ["comments"]),
    )
