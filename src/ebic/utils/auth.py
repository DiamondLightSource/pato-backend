from .config import Config


def is_admin(perms: list[int]):
    return bool(set(Config.get()["auth"]["read_all_perms"]) & set(perms))


def is_em_staff(perms: list[int]):
    return bool(set(Config.get()["auth"]["read_em_perms"]) & set(perms))


def check_admin(func):
    def wrap(*args, **kwargs):
        user = args[0]
        query = args[1]

        if is_admin(user.permissions):
            return query

        return func(*args, **kwargs)

    return wrap
