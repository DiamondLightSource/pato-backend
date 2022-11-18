# flake8: noqa F401
import os

auth_type = os.environ.get("AUTH_TYPE") or "oidc"


if auth_type.lower() == "oidc":
    from ..extensions.auth.oidc import AuthUser
elif auth_type.lower() == "dummy":
    from ..extensions.auth.dummy import AuthUser  # type: ignore
