from pydantic import BaseModel


class Unauthorised(BaseModel):
    detail: str
