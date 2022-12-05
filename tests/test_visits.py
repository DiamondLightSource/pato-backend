import pytest

from .users import admin, em_admin, user


@pytest.mark.parametrize("override_user", [admin], indirect=True)
def test_get_admin(override_user, client):
    """Get all visits (request from admin)"""
    resp = client.get("/visits?prop=cm14451")
    assert resp.status_code == 200
    assert resp.json()["total"] == 3


@pytest.mark.parametrize("override_user", [admin], indirect=True)
def test_get_inexistent_proposal(override_user, client):
    """Try to get visits for proposal that does not exist"""
    resp = client.get("/visits?prop=xx12345")
    assert resp.status_code == 404


@pytest.mark.parametrize("override_user", [em_admin], indirect=True)
def test_get_em_admin(override_user, client):
    """Get all visits belonging to EM (request from EM admin)"""
    resp = client.get("/visits?prop=cm31111")
    assert resp.status_code == 200
    assert resp.json()["total"] == 2


@pytest.mark.parametrize("override_user", [user], indirect=True)
def test_get_user(override_user, client):
    """Get all visits belonging to a regular user"""
    resp = client.get("/visits?prop=cm31111")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@pytest.mark.parametrize("override_user", [user], indirect=True)
def test_get_forbidden(override_user, client):
    """Try to get visits for proposal that does not belong to an user"""
    resp = client.get("/visits?prop=cm14451")
    assert resp.status_code == 404
