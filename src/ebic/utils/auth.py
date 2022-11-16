import os

import requests
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer

from ..models.table import Person
from ..models.table import t_UserGroup_has_Permission as GroupHasPerm
from ..models.table import t_UserGroup_has_Person as GroupHasPerson
from .database import db


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


def check_admin(token: str = Depends(oauth2_scheme)):
    user = (
        db.session.query(Person.personId)
        .filter(Person.login == get_user(token)["id"])
        .first()
    )

    if user is None:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="User is not listed or does not have permission to view content",
        )

    # This is being done because otherwise SQLAlchemy would build a massive query based
    # on the relationships in the model; this is slightly better:
    query = (
        db.session.query(GroupHasPerm.columns.permissionId)
        .select_from(GroupHasPerson)
        .filter(GroupHasPerson.columns.personId == user.personId)
        .join(
            GroupHasPerm,
            GroupHasPerm.columns.userGroupId == GroupHasPerson.columns.userGroupId,
        )
    )

    return {"id": user, "permissions": [p.permissionId for p in query.all()]}


def get_logout_redirect():
    return oidc_endpoints["end_session_endpoint"]
