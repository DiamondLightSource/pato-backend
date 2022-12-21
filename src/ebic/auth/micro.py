import requests
from fastapi import Depends, HTTPException
from fastapi.security import OAuth2PasswordBearer

from ..utils.config import Config
from .template import GenericPermissions, GenericUser

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")


class User(GenericUser):
    def __init__(self, token=Depends(oauth2_scheme)):
        response = requests.get(
            Config.auth.endpoint + "user",
            headers={"Authorization": f"Bearer {token}"},
        )

        if response.status_code != 200:
            raise HTTPException(
                status_code=response.status_code, detail=response.json().get("detail")
            )

        super().__init__(**response.json())


def _check_perms(data_id: str | int, endpoint: str, token=str):
    response = requests.get(
        "".join(
            [
                Config.auth.endpoint,
                "permission/",
                endpoint,
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


class Permissions(GenericPermissions):
    @staticmethod
    def collection(collectionId: int, token=Depends(oauth2_scheme)):
        return _check_perms(collectionId, "collection", token)

    @staticmethod
    def tomogram(tomogramId: int, token=Depends(oauth2_scheme)):
        return _check_perms(tomogramId, "tomogram", token)

    @staticmethod
    def movie(movieId: int, token=Depends(oauth2_scheme)):
        return _check_perms(movieId, "movie", token)
