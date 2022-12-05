import pytest

from .users import admin, em_admin, user


@pytest.mark.parametrize("override_user", [admin], indirect=True)
def test_get_admin(override_user, client):
    """Get all proposals (request for admin)"""
    resp = client.get("/proposals")
    assert resp.status_code == 200
    assert resp.json()["total"] == 4


@pytest.mark.parametrize("override_user", [admin], indirect=True)
def test_search_code(override_user, client):
    """Get all proposals with a matching proposal code"""
    resp = client.get("/proposals?s=bi")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@pytest.mark.parametrize("override_user", [admin], indirect=True)
def test_search_number(override_user, client):
    """Get all proposals with a matching proposal number"""
    resp = client.get("/proposals?s=1")
    assert resp.status_code == 200
    assert resp.json()["total"] == 3


@pytest.mark.parametrize("override_user", [admin], indirect=True)
def test_search_full(override_user, client):
    """Get all proposals with a matching proposal code and number"""
    resp = client.get("/proposals?s=cm31")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@pytest.mark.parametrize("override_user", [em_admin], indirect=True)
def test_get_em_admin(override_user, client):
    """Get all proposals belonging to EM (request for EM admin)"""
    resp = client.get("/proposals")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@pytest.mark.parametrize("override_user", [user], indirect=True)
def test_get_user(override_user, client):
    """Get proposals belonging to a regular user"""
    resp = client.get("/proposals")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1
