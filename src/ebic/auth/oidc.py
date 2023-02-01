from typing import Literal

import requests
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer

from ..auth import is_admin, is_em_staff
from ..models.response import Tomogram
from ..models.table import BLSession, DataCollection, Movie, Person, SessionHasPerson
from ..models.table import t_UserGroup_has_Permission as GroupHasPerm
from ..models.table import t_UserGroup_has_Person as GroupHasPerson
from ..utils.config import Config
from ..utils.database import db
from .template import GenericPermissions, GenericUser


def _discovery():
    return requests.get(Config.auth.endpoint).json()


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")
oidc_endpoints = _discovery()


def _session_exists(session: int):
    if db.session.query(BLSession).filter_by(sessionId=session).scalar() is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Session does not exist",
        )


class User(GenericUser):
    def __init__(self, token=Depends(oauth2_scheme)):
        super().__init__(token)

    def auth(self, token: str):
        response = requests.get(
            oidc_endpoints["userinfo_endpoint"],
            headers={"Authorization": f"Bearer {token}"},
        )

        if response.status_code == 401:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid user token",
            )

        user: Person = (
            db.session.query(Person)
            .filter(Person.login == response.json()["id"])
            .first()
        )

        if user is None:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="User is not listed or does not have permission to view content",
            )

        # This is being done because otherwise SQLAlchemy would build a massive
        # query based on the relationships in the model; this is slightly better:
        query = (
            db.session.query(GroupHasPerm.columns.permissionId)
            .select_from(GroupHasPerson)
            .filter(GroupHasPerson.columns.personId == self.id)
            .join(
                GroupHasPerm,
                GroupHasPerm.columns.userGroupId == GroupHasPerson.columns.userGroupId,
            )
        )

        self.id = user.personId
        self.familyName = user.familyName
        self.title = user.title
        self.givenName = user.givenName
        self.permissions = [p.permissionId for p in query.all()]

    @classmethod
    def get_auth_redirect(cls, redirect: str):
        return (
            oidc_endpoints["authorization_endpoint"]
            + "?response_type=token&client_id=oidc_diamond_ac_uk&redirect_uri="
            + redirect
        )

    @classmethod
    def get_logout_redirect(cls):
        return oidc_endpoints["end_session_endpoint"]


def _session_check(user: User, session: int) -> Literal[True]:
    """Checks if the user has permission to view data related to a session,
    or raises an error"""
    if session is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Object does not exist in database",
        )

    if is_admin(user.permissions):
        _session_exists(session)
        return True

    if is_em_staff(user.permissions):
        if (
            db.session.query(BLSession.sessionId)
            .filter(
                BLSession.sessionId == session,
                BLSession.beamLineName.like("m__"),
            )
            .scalar()
            is not None
        ):
            return True

    if (
        db.session.query(SessionHasPerson.sessionId)
        .filter_by(sessionId=session, personId=user.id)
        .scalar()
        is not None
    ):
        return True

    _session_exists(session)

    raise HTTPException(
        status_code=status.HTTP_403_FORBIDDEN,
        detail="User not in the parent session",
    )


def _validate_collection(user: User, col_id: int):
    session_id = (
        db.session.query(DataCollection.SESSIONID)
        .filter(DataCollection.dataCollectionId == col_id)
        .scalar()
    )

    return _session_check(user, session_id)


def _validate_tomogram(user: User, tomo_id: int):
    session_id = (
        db.session.query(DataCollection.SESSIONID)
        .select_from(Tomogram)
        .filter_by(tomogramId=tomo_id)
        .join(
            DataCollection,
            DataCollection.dataCollectionId == Tomogram.dataCollectionId,
        )
    ).scalar()

    return _session_check(user, session_id)


def _validate_movie(user: User, mov_id: int):
    session_id = (
        db.session.query(DataCollection.SESSIONID)
        .select_from(Movie)
        .filter(Movie.movieId == mov_id)
        .join(
            DataCollection,
            DataCollection.dataCollectionId == Movie.dataCollectionId,
        )
    ).scalar()

    return _session_check(user, session_id)


_validation = {
    "movie": _validate_movie,
    "collection": _validate_collection,
    "tomogram": _validate_tomogram,
}


class Permissions(GenericPermissions):
    def __init__(self, endpoint: str):
        self.endpoint = endpoint

    def __call__(self, data_id: int | str, user=Depends(User)):
        _validation[self.endpoint](user, int(data_id))
        return data_id
