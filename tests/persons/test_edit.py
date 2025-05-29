import pytest
from lims_utils.auth import GenericUser
from lims_utils.tables import Person
from sqlalchemy import select

from pato.utils.database import db

from ..users import user

invalid_user = GenericUser(fedid="invalid", id=0, title="Dr", givenName="Invalid", familyName="User", permissions=[])

@pytest.mark.parametrize("mock_user", [user], indirect=True)
def test_edit(mock_user, client):
    """Should update user's own email"""
    resp = client.patch("/me", json={"emailAddress": "test@diamond.ac.uk"})

    assert resp.status_code == 200

    email = db.session.scalar(select(Person.emailAddress).filter(Person.login == "user"))

    assert email == "test@diamond.ac.uk"

@pytest.mark.parametrize("mock_user", [invalid_user], indirect=True)
def test_edit_invalid_user(mock_user, client):
    """Should return error if invalid user is provided"""
    resp = client.patch("/me", json={"emailAddress": "test@diamond.ac.uk"})

    assert resp.status_code == 404

@pytest.mark.parametrize("mock_user", [user], indirect=True)
def test_edit_invalid(mock_user, client):
    """Should return error if invalid email is provided"""
    resp = client.patch("/me", json={"emailAddress": "invalid-email"})

    assert resp.status_code == 422
