# flake8: noqa F401
import os

from .config import Config

auth_type = os.environ.get("AUTH_TYPE") or "oidc"


if auth_type.lower() == "oidc":
    from ..auth.oidc import AuthUser
elif auth_type.lower() == "dummy":
    from ..auth.dummy import AuthUser  # type: ignore


def is_admin(perms: list[int]):
    return bool(set(Config.get()["auth"]["read_all_perms"]) & set(perms))


def is_em_staff(perms: list[int]):
    return bool(set(Config.get()["auth"]["read_em_perms"]) & set(perms))
