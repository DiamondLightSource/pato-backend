# flake8: noqa F401
from .config import Config

auth_type = Config.get()["auth"]["type"]

if auth_type.lower() == "micro":
    from ..auth.micro import Permissions, User
elif auth_type.lower() == "dummy":
    from ..auth.template import GenericPermissions as Permissions
    from ..auth.template import GenericUser as User


def is_admin(perms: list[int]):
    return bool(set(Config.get()["auth"]["read_all_perms"]) & set(perms))


def is_em_staff(perms: list[int]):
    return bool(set(Config.get()["auth"]["read_em_perms"]) & set(perms))
