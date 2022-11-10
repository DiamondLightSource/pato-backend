import os

import requests
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer


def discovery():
    return requests.get(
        os.environ.get(
            "OIDC_DISCOVERY_ENDPOINT",
            "https://authalpha.diamond.ac.uk/cas/oidc/.well-known",
        )
    ).json()


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")
oidc_endpoints = discovery()


def get_user(token: str = Depends(oauth2_scheme)):
    response = requests.get(
        oidc_endpoints["userinfo_endpoint"],
        headers={"Authorization": f"Bearer {token}"},
    )

    if response.status_code == 401:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid user token",
        )

    return {"id": response.json()["id"]}


def get_auth_redirect(redirect: str):
    return (
        oidc_endpoints["authorization_endpoint"]
        + "?response_type=token&client_id=oidc_diamond_ac_uk&redirect_uri="
        + redirect
    )


def get_logout_redirect():
    return oidc_endpoints["end_session_endpoint"]
