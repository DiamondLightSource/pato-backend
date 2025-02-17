from typing import Literal

from pydantic import BaseModel


class DataCollectionCreationParameters(BaseModel):
    fileDirectory: str
    fileExtension: str


# mypy doesn't support type aliases yet

DataCollectionSortTypes = Literal["dataCollectionId", "globalAlignmentQuality", ""]
