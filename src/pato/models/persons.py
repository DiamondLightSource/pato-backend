from pydantic import BaseModel, EmailStr


class PersonBase(BaseModel):
    familyName: str | None = None
    givenName: str | None = None
    emailAddress: str | None = None
    title: str | None = None
    login: str | None = None


class PersonIn(BaseModel):
    emailAddress: EmailStr

class PersonOut(PersonBase):
    pass
