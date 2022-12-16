from dataclasses import dataclass


@dataclass
class GenericUser:
    fedid: str
    id: str
    family_name: str
    title: str
    given_name: str
    permissions: list[int]


class GenericPermissions:
    @staticmethod
    def collection(collectionId: int) -> int:
        return collectionId

    @staticmethod
    def tomogram(tomogramId: int) -> int:
        return tomogramId

    @staticmethod
    def movie(movieId: int) -> int:
        return movieId
