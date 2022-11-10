from fastapi import APIRouter, Depends
from fastapi.responses import RedirectResponse

from ..models.api import Unauthorized
from ..utils.auth import get_auth_redirect, get_logout_redirect, get_user

router = APIRouter(tags=["auth"], responses={401: {"model": Unauthorized}})


@router.get("/user")
def check_user(user=Depends(get_user)):
    """Check user authentication status"""
    return user


@router.get("/authorise", status_code=302, response_class=RedirectResponse)
def authorise_user(redirect_uri: str):
    """Redirect user to authorisation page"""
    return get_auth_redirect(redirect_uri)


@router.get("/logout", status_code=302, response_class=RedirectResponse)
def logout():
    """Redirect user to logout page"""
    return get_logout_redirect()
