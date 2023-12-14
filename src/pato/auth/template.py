from dataclasses import dataclass

from ..utils.generic import parse_proposal


@dataclass
class GenericUser:
    fedid: str
    id: str
    familyName: str
    title: str
    givenName: str
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

    @staticmethod
    def autoproc_program(autoProcProgramId: int) -> int:
        return autoProcProgramId

    @staticmethod
    def processing_job(processingJobId: int) -> int:
        return processingJobId

    @staticmethod
    def session(proposalReference: str, visitNumber: int):
        return parse_proposal(proposalReference, visitNumber)
