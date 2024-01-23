from lims_utils.auth import GenericUser

from .template import GenericPermissions


class User(GenericUser):
    def __init__(self, token=""):
        super().__init__(token)

    @classmethod
    def auth(cls, _: str):
        return "aaa1111"


class Permissions(GenericPermissions):
    pass
