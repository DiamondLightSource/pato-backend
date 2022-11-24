import requests
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer

from ..utils.config import Config
from .template import GenericAuthUser


def _discovery():
    return requests.get(Config.get["auth"]["oidc_discovery_endpoint"]).json()


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")
oidc_endpoints = _discovery()


class AuthUser(GenericAuthUser):
    def __init__(self, token=Depends(oauth2_scheme)):
        super().__init__(token)

    @classmethod
    def auth(cls, token: str):
        response = requests.get(
            oidc_endpoints["userinfo_endpoint"],
            headers={"Authorization": f"Bearer {token}"},
        )

        if response.status_code == 401:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid user token",
            )

        return response.json()["id"]

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
