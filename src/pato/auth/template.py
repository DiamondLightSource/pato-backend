from ..utils.generic import parse_proposal


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
    def autoproc_program(autoProcId: int) -> int:
        return autoProcId

    @staticmethod
    def processing_job(processingJobId: int) -> int:
        return processingJobId

    @staticmethod
    def session(proposalReference: str, visitNumber: int):
        return parse_proposal(proposalReference, visitNumber)

    @staticmethod
    def data_collection_group(groupId: int) -> int:
        return groupId

    @staticmethod
    def grid_square(gridSquareId: int) -> int:
        return gridSquareId

    @staticmethod
    def foil_hole(foilHoleId: int) -> int:
        return foilHoleId
