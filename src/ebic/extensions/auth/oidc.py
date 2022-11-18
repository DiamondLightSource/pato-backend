import os

import requests
from fastapi import HTTPException, status
from fastapi.security import OAuth2PasswordBearer


def _discovery():
    return requests.get(
        os.environ.get(
            "OIDC_DISCOVERY_ENDPOINT",
            "https://authalpha.diamond.ac.uk/cas/oidc/.well-known",
        )
    ).json()


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")
oidc_endpoints = _discovery()


def auth(token: str):
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


def oidc_auth_redirect(redirect: str):
    return (
        oidc_endpoints["authorization_endpoint"]
        + "?response_type=token&client_id=oidc_diamond_ac_uk&redirect_uri="
        + redirect
    )


def oidc_logout_redirect():
    return oidc_endpoints["end_session_endpoint"]
