import pytest

from .users import admin, em_admin, mx_admin, user


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_get_admin(mock_user, client):
    """Get all proposals (request for admin)"""
    resp = client.get("/proposals")
    assert resp.status_code == 200
    assert resp.json()["total"] == 4


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_search_code(mock_user, client):
    """Get all proposals with a matching proposal code"""
    resp = client.get("/proposals?search=bi")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_search_number(mock_user, client):
    """Get all proposals with a matching proposal number"""
    resp = client.get("/proposals?search=1")
    assert resp.status_code == 200
    assert resp.json()["total"] == 3


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_search_full(mock_user, client):
    """Get all proposals with a matching proposal code and number"""
    resp = client.get("/proposals?search=cm31")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@pytest.mark.parametrize("mock_user", [em_admin], indirect=True)
def test_get_em_admin(mock_user, client):
    """Get all proposals belonging to EM (request for EM admin)"""
    resp = client.get("/proposals")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@pytest.mark.parametrize("mock_user", [mx_admin], indirect=True)
def test_get_mx_admin(mock_user, client):
    """Get all proposals belonging to MX (request for MX admin)"""
    resp = client.get("/proposals")
    assert resp.status_code == 200
    assert resp.json()["total"] == 2


@pytest.mark.parametrize("mock_user", [user], indirect=True)
def test_get_user(mock_user, client):
    """Get proposals belonging to a regular user"""
    resp = client.get("/proposals")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1
