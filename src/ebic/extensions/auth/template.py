from fastapi import HTTPException, status
from fastapi.security import OAuth2PasswordBearer

from ...models.table import Person
from ...models.table import t_UserGroup_has_Permission as GroupHasPerm
from ...models.table import t_UserGroup_has_Person as GroupHasPerson
from ...utils.database import db

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")


class GenericAuthUser:
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

    @classmethod
    def auth(cls, token: str) -> str:
        raise NotImplementedError

    @classmethod
    def get_auth_redirect(cls, redirect: str) -> str:
        raise NotImplementedError

    @classmethod
    def get_logout_redirect(cls) -> str:
        raise NotImplementedError
