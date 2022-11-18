import os

from fastapi import HTTPException, status

from ..models.table import Person
from ..models.table import t_UserGroup_has_Permission as GroupHasPerm
from ..models.table import t_UserGroup_has_Person as GroupHasPerson
from ..utils.database import db


class AuthUser:
    def __init__(self, token: str):
        self.fedid = self.auth(token)

        user = (
            db.session.query(Person.personId).filter(Person.login == self.fedid).first()
        )

        if user is None:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="User is not listed or does not have permission to view content",
            )

        self.id = user.personId
        self._permissions: list[int] = []

    @property
    def permissions(self):
        if not self._permissions:
            # This is being done because otherwise SQLAlchemy would build a massive
            # query based on the relationships in the model; this is slightly better:
            query = (
                db.session.query(GroupHasPerm.columns.permissionId)
                .select_from(GroupHasPerson)
                .filter(GroupHasPerson.columns.personId == self.id)
                .join(
                    GroupHasPerm,
                    GroupHasPerm.columns.userGroupId
                    == GroupHasPerson.columns.userGroupId,
                )
            )

            self._permissions = [p.permissionId for p in query.all()]
        return self._permissions

    @staticmethod
    def auth(token: str) -> str:
        raise NotImplementedError

    @staticmethod
    def get_auth_redirect(redirect: str) -> str:
        raise NotImplementedError

    @staticmethod
    def get_logout_redirect() -> str:
        raise NotImplementedError


auth_type = os.environ.get("AUTH_TYPE") or "oidc"

if auth_type.lower() == "oidc":
    from ..extensions.auth.oidc import auth, oidc_auth_redirect, oidc_logout_redirect

    AuthUser.auth = auth
    AuthUser.get_auth_redirect = oidc_auth_redirect
    AuthUser.get_logout_redirect = oidc_logout_redirect
elif auth_type.lower() == "dummy":
    from ..extensions.auth.dummy import auth, auth_redirect, logout_redirect

    print("DUMMY AUTHENTICATION - DO NOT USE IN PROD")

    AuthUser.auth = auth
    AuthUser.get_auth_redirect = auth_redirect
    AuthUser.get_logout_redirect = logout_redirect
