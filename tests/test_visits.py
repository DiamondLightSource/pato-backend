from unittest.mock import patch

from ebic.utils.auth import AuthUser


@patch.object(AuthUser, "auth", return_value="admin", autospec=True)
def test_get_admin(mock_user, client):
    """Get all visits (request from admin)"""
    resp = client.get("/visits?prop=cm14451")
    assert resp.status_code == 200
    assert resp.json()["total"] == 3


@patch.object(AuthUser, "auth", return_value="admin", autospec=True)
def test_get_inexistent_proposal(mock_user, client):
    """Try to get visits for proposal that does not exist"""
    resp = client.get("/visits?prop=xx12345")
    assert resp.status_code == 404


@patch.object(AuthUser, "auth", return_value="em_admin", autospec=True)
def test_get_em_admin(mock_user, client):
    """Get all visits belonging to EM (request from EM admin)"""
    resp = client.get("/visits?prop=cm31111")
    assert resp.status_code == 200
    assert resp.json()["total"] == 2


@patch.object(AuthUser, "auth", return_value="user", autospec=True)
def test_get_user(mock_user, client):
    """Get all visits belonging to a regular user"""
    resp = client.get("/visits?prop=cm31111")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@patch.object(AuthUser, "auth", return_value="user", autospec=True)
def test_get_forbidden(mock_user, client):
    """Try to get visits for proposal that does not belong to an user"""
    resp = client.get("/visits?prop=cm14451")
    assert resp.status_code == 404
