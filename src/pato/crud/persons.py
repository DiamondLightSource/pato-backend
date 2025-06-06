from fastapi import HTTPException, status
from lims_utils.auth import GenericUser
from lims_utils.tables import Person
from sqlalchemy import select, update

from ..models.persons import PersonIn
from ..utils.database import db


def update_user_info(user: GenericUser, parameters: PersonIn):
    db.session.execute(
        update(Person)
        .filter(Person.personId == user.id)
        .values(parameters.model_dump(exclude_unset=True))
    )

    if (new_user := db.session.scalar(select(Person).filter(Person.personId == user.id))) is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    db.session.commit()

    return new_user
