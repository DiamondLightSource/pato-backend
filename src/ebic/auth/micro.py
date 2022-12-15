import requests
from fastapi import Depends, HTTPException
from fastapi.security import OAuth2PasswordBearer

from ..utils.config import Config
from .template import GenericPermissions, GenericUser

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")


class User(GenericUser):
    def __init__(self, token=Depends(oauth2_scheme)):
        response = requests.get(
            Config.get()["auth"]["endpoint"] + "user",
            headers={"Authorization": f"Bearer {token}"},
        )

        if response.status_code != 200:
            raise HTTPException(
                status_code=response.status_code, detail=response.json().get("detail")
            )

        super().__init__(**response.json())


class Permissions(GenericPermissions):
    def __init__(self, endpoint: str):
        self.endpoint = endpoint

    def __call__(self, data_id: int | str, token=Depends(oauth2_scheme)):
        response = requests.get(
            "".join(
                [
                    Config.get()["auth"]["endpoint"],
                    "permission/",
                    self.endpoint,
                    "/",
                    str(data_id),
                ]
            ),
            headers={"Authorization": f"Bearer {token}"},
        )

        if response.status_code != 200:
            raise HTTPException(
                status_code=response.status_code, detail=response.json().get("detail")
            )

        return data_id
