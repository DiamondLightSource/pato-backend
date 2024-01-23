import requests
from fastapi import Depends, HTTPException, Request
from fastapi.security import HTTPAuthorizationCredentials
from lims_utils.auth import CookieOrHTTPBearer, GenericUser

from ..utils.config import Config
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


def _check_perms(data_id: str | int, endpoint: str, token: str):
    response = requests.get(
        "".join(
            [
                Config.auth.endpoint,
                "permission/",
                endpoint,
                "/",
                str(data_id),
            ]
        ),
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
