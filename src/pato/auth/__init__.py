# flake8: noqa F401
import importlib

from ..utils.config import Config
from .template import GenericPermissions, GenericUser

auth_type = Config.auth.type.lower()


def is_admin(perms: list[int]):
    return bool(set(Config.auth.read_all_perms) & set(perms))


_current_auth = importlib.import_module("pato.auth." + auth_type)

_Permissions = _current_auth.Permissions
_User = _current_auth.User

assert issubclass(_Permissions, GenericPermissions)
assert issubclass(_User, GenericUser)

Permissions: GenericPermissions = _Permissions
User: GenericUser = _User
