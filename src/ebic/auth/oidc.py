import requests
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer

from ..models.table import Person
from ..models.table import t_UserGroup_has_Permission as GroupHasPerm
from ..models.table import t_UserGroup_has_Person as GroupHasPerson
from ..utils.config import Config
from ..utils.database import db
from .template import GenericAuthUser


def _discovery():
    return requests.get(Config.get()["auth"]["endpoint"]).json()


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")
oidc_endpoints = _discovery()


class AuthUser(GenericAuthUser):
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
        self.family_name = user.familyName
        self.title = user.title
        self.given_name = user.givenName
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
