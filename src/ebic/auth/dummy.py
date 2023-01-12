from .template import GenericUser


class User(GenericUser):
    def __init__(self, token=""):
        super().__init__(token)

    @classmethod
    def auth(cls, _: str):
        return "aaa1111"
