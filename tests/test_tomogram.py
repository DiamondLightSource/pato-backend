from unittest.mock import patch

from ebic.utils.auth import AuthUser


@patch.object(AuthUser, "auth", return_value="admin", autospec=True)
def test_get_admin(mock_user, client):
    """Get all tomograms in a data collection (request for admin)"""
    resp = client.get("/dataCollections/6017406/tomogram")
    assert resp.status_code == 200


@patch.object(AuthUser, "auth", return_value="em_admin", autospec=True)
def test_get_em_admin(mock_user, client):
    """Get tomogram in a data collection (request for EM admin).
    Non-EM tomograms cannot exist."""
    resp = client.get("/dataCollections/6017406/tomogram")
    assert resp.status_code == 200


@patch.object(AuthUser, "auth", return_value="user", autospec=True)
def test_get_user(mock_user, client):
    """Get all tomograms in a data collection belonging to user"""
    resp = client.get("/dataCollections/6017408/tomogram")
    assert resp.status_code == 200


@patch.object(AuthUser, "auth", return_value="user", autospec=True)
def test_get_forbidden(mock_user, client):
    """Try to get tomograms in a data collection that does not belong to user"""
    resp = client.get("/dataCollections/6017406/tomogram")
    assert resp.status_code == 403
