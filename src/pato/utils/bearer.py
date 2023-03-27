from typing import Optional

from fastapi import HTTPException, Request, status
from fastapi.openapi.models import OAuthFlows as OAuthFlowsModel
from fastapi.security import OAuth2
from fastapi.security.utils import get_authorization_scheme_param


class OAuth2PasswordBearerCookie(OAuth2):
    def __init__(
        self,
        tokenUrl: str,
        scheme_name: Optional[str] = None,
        scopes: Optional[dict] = None,
    ):
        if scopes is None:
            scopes = {}
        flows = OAuthFlowsModel(password={"tokenUrl": tokenUrl, "scopes": scopes})
        super().__init__(flows=flows, scheme_name=scheme_name, auto_error=True)

    async def __call__(self, request: Request) -> Optional[str]:
        token = request.cookies.get("diamond-uauth-session")

        if token is not None:
            return token

        authorization = request.headers.get("Authorization")
        scheme, param = get_authorization_scheme_param(authorization)

        if scheme != "Bearer" or not param:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED, detail="Not authenticated"
            )

        return param
