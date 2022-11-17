from fastapi import HTTPException, status
from sqlalchemy.orm import Query

from ..models.table import BLSession, DataCollection, Movie, SessionHasPerson, Tomogram
from ..utils.auth import AuthUser
from ..utils.database import db


def _session_check(query: Query, user: AuthUser, data):
    if not data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Data not found",
        )

    if bool(set([11, 26]) & set(user.permissions)):
        return data

    if bool(set([8]) & set(user.permissions)):
        query = query.filter(
            BLSession.sessionId == DataCollection.SESSIONID,
            BLSession.beamLineName.like("m__"),
        )
    else:
        query = query.filter(
            SessionHasPerson.sessionId == DataCollection.SESSIONID,
            SessionHasPerson.personId == user.id,
        )

    if query.scalar() is None:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="User not in the parent session",
        )

    return data


def validate_collection(func):
    def wrap(*args, **kwargs):
        user = args[0]
        col_id = args[1]

        data = func(*args, **kwargs)

        query = db.session.query(DataCollection).filter(
            DataCollection.dataCollectionId == col_id
        )

        return _session_check(query, user, data)

    return wrap


def validate_tomogram(func):
    def wrap(*args, **kwargs):
        user = args[0]
        tomo_id = args[1]

        data = func(*args, **kwargs)

        query = (
            db.session.query(DataCollection)
            .select_from(Tomogram)
            .filter(Tomogram.tomogramId == tomo_id)
            .join(
                DataCollection,
                DataCollection.dataCollectionId == Tomogram.dataCollectionId,
            )
        )

        return _session_check(query, user, data)

    return wrap


def validate_movie(func):
    def wrap(*args, **kwargs):
        user = args[0]
        mov_id = args[1]

        data = func(*args, **kwargs)

        query = (
            db.session.query(DataCollection)
            .select_from(Movie)
            .filter(Movie.movieId == mov_id)
            .join(
                DataCollection,
                DataCollection.dataCollectionId == Movie.dataCollectionId,
            )
        )

        return _session_check(query, user, data)

    return wrap
