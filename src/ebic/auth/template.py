from dataclasses import dataclass


@dataclass
class GenericAuthUser:
    id: str
    family_name: str
    title: str
    given_name: str
    permissions: list[int]
