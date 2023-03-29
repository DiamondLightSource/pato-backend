from pydantic import BaseModel


class ReprocessingParameters(BaseModel):
    pixelSize: int
    tiltOffset: float
