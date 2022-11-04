from fastapi import APIRouter, Depends
from fastapi.responses import JSONResponse
from fastapi.security import OAuth2PasswordRequestForm

from ..models.api import Unauthorized
from ..utils.auth import auth_and_generate_token, get_user

router = APIRouter(tags=["auth"], responses={401: {"model": Unauthorized}})


@router.post("/login")
def login(json: OAuth2PasswordRequestForm = Depends()):
    if json.username != "dummy":
        return JSONResponse(status_code=401, content={"detail": "Invalid credentials"})

    return {"token": auth_and_generate_token(json.username)}


@router.post("/logout")
def logout():
    return


@router.get("/user")
def check_user(user=Depends(get_user)):
    return user
