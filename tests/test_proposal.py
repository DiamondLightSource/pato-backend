from unittest.mock import patch

from ebic.utils.auth import AuthUser


@patch.object(AuthUser, "auth", return_value="admin", autospec=True)
def test_get_admin(mock_user, client):
    """Get all proposals (request for admin)"""
    resp = client.get("/proposals")
    assert resp.status_code == 200
    assert resp.json()["total"] == 4


@patch.object(AuthUser, "auth", return_value="admin", autospec=True)
def test_search_code(mock_user, client):
    """Get all proposals with a matching proposal code"""
    resp = client.get("/proposals?s=bi")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@patch.object(AuthUser, "auth", return_value="admin", autospec=True)
def test_search_number(mock_user, client):
    """Get all proposals with a matching proposal number"""
    resp = client.get("/proposals?s=1")
    assert resp.status_code == 200
    assert resp.json()["total"] == 3


@patch.object(AuthUser, "auth", return_value="admin", autospec=True)
def test_search_full(mock_user, client):
    """Get all proposals with a matching proposal code and number"""
    resp = client.get("/proposals?s=cm31")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@patch.object(AuthUser, "auth", return_value="em_admin", autospec=True)
def test_get_em_admin(mock_user, client):
    """Get all proposals belonging to EM (request for EM admin)"""
    resp = client.get("/proposals")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@patch.object(AuthUser, "auth", return_value="user", autospec=True)
def test_get_user(mock_user, client):
    """Get proposals belonging to a regular user"""
    resp = client.get("/proposals")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@patch.object(AuthUser, "auth", return_value="empty", autospec=True)
def test_get_forbidden(mock_user, client):
    """Try to get proposals for user with no proposals"""
    resp = client.get("/proposals")
    assert resp.status_code == 404
