import requests
from fastapi import Depends, HTTPException
from fastapi.security import OAuth2PasswordBearer

from ..utils.config import Config
from .template import GenericAuthUser

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")


class AuthUser(GenericAuthUser):
    def __init__(self, token=Depends(oauth2_scheme)):
        response = requests.get(
            Config.get()["auth"]["endpoint"],
            headers={"Authorization": f"Bearer {token}"},
        )

        if response.status_code != 200:
            raise HTTPException(
                status_code=response.status_code, detail=response.json()
            )

        super().__init__(**response.json())
