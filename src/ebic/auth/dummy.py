from .template import GenericAuthUser


class AuthUser(GenericAuthUser):
    def __init__(self, token=""):
        super().__init__(token)

    @classmethod
    def auth(cls, _: str):
        return "aaa1111"
