import pytest

from ..users import admin, em_admin, mx_admin, user


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_get_admin(mock_user, client):
    """Get all visits (request from admin)"""
    resp = client.get("/sessions?proposal=cm14451")
    assert resp.status_code == 200
    assert resp.json()["total"] == 3


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_get_inexistent_proposal(mock_user, client):
    """Try to get visits for proposal that does not exist"""
    resp = client.get("/sessions?proposal=xx12345")
    assert resp.status_code == 404


@pytest.mark.parametrize("mock_user", [em_admin], indirect=True)
def test_get_em_admin(mock_user, client):
    """Get all visits belonging to EM (request from EM admin)"""
    resp = client.get("/sessions?proposal=cm31111")
    assert resp.status_code == 200
    assert resp.json()["total"] == 2


@pytest.mark.parametrize("mock_user", [user], indirect=True)
def test_get_user(mock_user, client):
    """Get all visits belonging to a regular user"""
    resp = client.get("/sessions?proposal=cm31111")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@pytest.mark.parametrize("mock_user", [mx_admin], indirect=True)
def test_get_mx_admin(mock_user, client):
    """Get all proposals belonging to MX (request for MX admin)"""
    resp = client.get("/sessions?proposal=cm1")
    assert resp.status_code == 200
    assert resp.json()["total"] == 3


@pytest.mark.parametrize("mock_user", [user], indirect=True)
def test_get_forbidden(mock_user, client):
    """Try to get visits for proposal that does not belong to an user"""
    resp = client.get("/sessions?proposal=cm14451")
    assert resp.status_code == 404


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_date(mock_user, client):
    """Try to get visits between two dates"""
    resp = client.get(
        "/sessions?minDate=2022-10-21 09:00:00.000&maxDate=2024-10-21 09:00:00.000"
    )
    assert resp.status_code == 200
    assert resp.json()["total"] == 2
