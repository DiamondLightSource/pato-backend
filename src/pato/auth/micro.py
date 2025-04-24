import requests
from fastapi import Depends, HTTPException, Request, status
from fastapi.security import HTTPAuthorizationCredentials
from lims_utils.auth import CookieOrHTTPBearer, GenericUser
from lims_utils.tables import (
    Atlas,
    BLSession,
    DataCollectionGroup,
    FoilHole,
    GridSquare,
)
from sqlalchemy import select

from ..utils.config import Config
from ..utils.database import db
from ..utils.generic import parse_proposal
from .template import GenericPermissions

oauth2_scheme = CookieOrHTTPBearer(cookie_key="diamond-uauth-session")


class User(GenericUser):
    def __init__(
        self,
        request: Request,
        token: HTTPAuthorizationCredentials = Depends(oauth2_scheme),
    ):
        response = requests.get(
            Config.auth.endpoint + "user",
            headers={"Authorization": f"Bearer {token.credentials}"},
        )

        if response.status_code != 200:
            raise HTTPException(
                status_code=response.status_code, detail=response.json().get("detail")
            )

        user = response.json()

        request.state.user = user.get("fedid")

        super().__init__(**user)


def _check_perms(data_id: str | int, endpoint: str, token: str, options: dict[str, str | int | bool] = {}):
    response = requests.get(
        "".join(
            [Config.auth.endpoint, "permission/", endpoint, "/", str(data_id)]
        ),
        params={**options, "usersOnly": True},
        headers={"Authorization": f"Bearer {token}"},
    )

    if response.status_code != 200:
        raise HTTPException(
            status_code=response.status_code, detail=response.json().get("detail")
        )

    return data_id


class Permissions(GenericPermissions):
    @staticmethod
    def session(
        proposalReference: str,
        visitNumber: int,
        token: HTTPAuthorizationCredentials = Depends(oauth2_scheme),
    ):
        _check_perms(f"{proposalReference}-{visitNumber}", "session", token.credentials)

        return parse_proposal(proposalReference, visitNumber)

    @staticmethod
    def collection(
        collectionId: int, token: HTTPAuthorizationCredentials = Depends(oauth2_scheme)
    ):
        return _check_perms(collectionId, "collection", token.credentials)

    @staticmethod
    def tomogram(
        tomogramId: int, token: HTTPAuthorizationCredentials = Depends(oauth2_scheme)
    ):
        return _check_perms(tomogramId, "tomogram", token.credentials)

    @staticmethod
    def movie(
        movieId: int, token: HTTPAuthorizationCredentials = Depends(oauth2_scheme)
    ):
        return _check_perms(movieId, "movie", token.credentials)

    @staticmethod
    def autoproc_program(
        autoProcId: int, token: HTTPAuthorizationCredentials = Depends(oauth2_scheme)
    ):
        return _check_perms(autoProcId, "autoProc", token.credentials)

    @staticmethod
    def processing_job(
        processingJobId: int,
        token: HTTPAuthorizationCredentials = Depends(oauth2_scheme),
    ):
        return _check_perms(processingJobId, "processingJob", token.credentials)

    @staticmethod
    def data_collection_group(
        groupId: int, token: HTTPAuthorizationCredentials = Depends(oauth2_scheme)
    ):
        session_id = db.session.scalar(
            select(BLSession.sessionId)
            .select_from(DataCollectionGroup)
            .filter(DataCollectionGroup.dataCollectionGroupId == groupId)
            .join(BLSession)
        )

        if session_id is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Data collection group not found",
            )

        _check_perms(session_id, "session", token.credentials, {"useId": True})

        return groupId

    @staticmethod
    def grid_square(
        gridSquareId: int, token: HTTPAuthorizationCredentials = Depends(oauth2_scheme)
    ):
        session_id = db.session.scalar(
            select(BLSession.sessionId)
            .select_from(GridSquare)
            .join(Atlas)
            .join(DataCollectionGroup)
            .join(BLSession)
            .filter(GridSquare.gridSquareId == gridSquareId)
        )

        if session_id is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Grid square not found",
            )

        _check_perms(session_id, "session", token.credentials, {"useId": True})

        return gridSquareId

    @staticmethod
    def foil_holes(
        foilHoleId: int, token: HTTPAuthorizationCredentials = Depends(oauth2_scheme)
    ):
        session_id = db.session.scalar(
            select(BLSession.sessionId)
            .select_from(FoilHole)
            .join(GridSquare)
            .join(Atlas)
            .join(DataCollectionGroup)
            .join(BLSession)
            .filter(FoilHole.foilHoleId == foilHoleId)
        )

        if session_id is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Foil hole not found",
            )

        _check_perms(session_id, "session", token.credentials, {"useId": True})

        return foilHoleId
