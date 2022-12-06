from dataclasses import dataclass


@dataclass
class GenericUser:
    id: str
    family_name: str
    title: str
    given_name: str
    permissions: list[int]


class GenericPermissions:
    def __init__(self, endpoint: str):
        pass
