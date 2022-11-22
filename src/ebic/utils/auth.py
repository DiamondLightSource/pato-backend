# flake8: noqa F401
import os

auth_type = os.environ.get("AUTH_TYPE") or "oidc"


if auth_type.lower() == "oidc":
    from ..auth.oidc import AuthUser
elif auth_type.lower() == "dummy":
    from ..auth.dummy import AuthUser  # type: ignore
