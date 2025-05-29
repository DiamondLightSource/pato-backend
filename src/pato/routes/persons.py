
from fastapi import APIRouter, Body, Depends

from ..auth import User
from ..crud import persons as crud
from ..models.persons import PersonIn, PersonOut

router = APIRouter(
    tags=["Persons"],
)


@router.patch("/me", response_model=PersonOut)
def update_user_info(user=Depends(User),
    parameters: PersonIn = Body()):
    """Update own user information"""
    return crud.update_user_info(user=user, parameters=parameters)
