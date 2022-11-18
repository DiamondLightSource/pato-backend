from fastapi import APIRouter
from fastapi.responses import RedirectResponse

from ..models.api import Unauthorized
from ..utils.auth import AuthUser

router = APIRouter(tags=["auth"], responses={401: {"model": Unauthorized}})


@router.get("/authorise", status_code=302, response_class=RedirectResponse)
def authorise_user(redirect_uri: str):
    """Redirect user to authorisation page"""
    return AuthUser.get_auth_redirect(redirect_uri)


@router.get("/logout", status_code=302, response_class=RedirectResponse)
def logout():
    """Redirect user to logout page"""
    return AuthUser.get_logout_redirect()
