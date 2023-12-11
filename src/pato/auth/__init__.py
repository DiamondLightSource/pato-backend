# flake8: noqa F401
from ..utils.config import Config

auth_type = Config.auth.type.lower()


def is_admin(perms: list[int]):
    return bool(set(Config.auth.read_all_perms) & set(perms))


if auth_type == "micro":
    pass
elif auth_type == "dummy":
    pass
