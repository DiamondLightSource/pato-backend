from dataclasses import dataclass

from fastapi.security import OAuth2PasswordBearer

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")


@dataclass
class GenericAuthUser:
    id: int
    family_name: str
    title: str
    given_name: str
    permissions: list[int]
