# flake8: noqa F401
from ..utils.config import Config

auth_type = Config.auth.type.lower()


def is_admin(perms: list[int]):
    return bool(set(Config.auth.read_all_perms) & set(perms))


if auth_type == "micro":
    from ..auth.micro import Permissions, User
elif auth_type == "dummy":
    from ..auth.template import GenericPermissions as Permissions
    from ..auth.template import GenericUser as User
