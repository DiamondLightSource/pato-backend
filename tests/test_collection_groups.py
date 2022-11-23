from unittest.mock import patch

from ebic.utils.auth import AuthUser


@patch.object(AuthUser, "auth", return_value="admin", autospec=True)
def test_get_admin(mock_user, client):
    """Get all data collection groups in a visit (request for admin)"""
    resp = client.get("/dataCollectionGroups?visit=27464088")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@patch.object(AuthUser, "auth", return_value="em_admin", autospec=True)
def test_get_em_admin(mock_user, client):
    """Get all collection groups in visit belonging to EM (request for EM admin)"""
    resp = client.get("/dataCollectionGroups?visit=27464088")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@patch.object(AuthUser, "auth", return_value="em_admin", autospec=True)
def test_get_non_em(mock_user, client):
    """Try to get all collection groups belonging to a non-EM visit (request for EM
    admin)"""
    resp = client.get("/dataCollectionGroups?visit=55168")
    assert resp.status_code == 404


@patch.object(AuthUser, "auth", return_value="user", autospec=True)
def test_get_user(mock_user, client):
    """Get data collection groups in a visit belonging to a regular user"""
    resp = client.get("/dataCollectionGroups?visit=27464089")
    assert resp.status_code == 200
    assert resp.json()["total"] == 3


@patch.object(AuthUser, "auth", return_value="user", autospec=True)
def test_get_forbidden(mock_user, client):
    """Try to get data collection groups for a visit that does not belong to user"""
    resp = client.get("/dataCollectionGroups?visit=27464088")
    assert resp.status_code == 404
