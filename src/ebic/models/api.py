from pydantic import BaseModel


class Unauthorized(BaseModel):
    detail: str
