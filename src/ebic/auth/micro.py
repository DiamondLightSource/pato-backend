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

        resp_json = response.json()

        self.permissions = resp_json["permissions"]
        self.given_name = resp_json["given_name"]
        self.title = resp_json["title"]
        self.id = resp_json["id"]
        self.family_name = resp_json["family_name"]
