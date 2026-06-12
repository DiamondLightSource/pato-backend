from pydantic import BaseModel


class AtlasCorrelationIn(BaseModel):
    """
    Correlation parameters for atlas correlation.
    """

    pair: int
