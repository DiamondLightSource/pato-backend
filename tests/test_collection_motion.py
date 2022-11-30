from unittest.mock import patch

from ebic.utils.auth import AuthUser


@patch.object(AuthUser, "auth", return_value="admin", autospec=True)
def test_get_admin(mock_user, client):
    """Get motion correction in a data collection (request for admin)"""
    resp = client.get("/dataCollections/6017406/motion")
    resp_json = resp.json()

    print(resp_json)

    assert resp.status_code == 200
    assert resp_json["total"] == 5


@patch.object(AuthUser, "auth", return_value="em_admin", autospec=True)
def test_get_em_admin(mock_user, client):
    """Get motion correction in a data collection (request for EM admin)."""
    resp = client.get("/dataCollections/6017406/motion")
    assert resp.status_code == 200
    assert resp.json()["total"] == 5


@patch.object(AuthUser, "auth", return_value="user", autospec=True)
def test_get_user(mock_user, client):
    """Get all motion correction in a data collection belonging to user"""
    resp = client.get("/dataCollections/6017408/motion")
    assert resp.status_code == 200
    assert resp.json()["total"] == 5


@patch.object(AuthUser, "auth", return_value="user", autospec=True)
def test_nth_motion(mock_user, client):
    """Get specific (nth) motion correction"""
    resp = client.get("/dataCollections/6017408/motion?nth=3")
    resp_json = resp.json()

    assert resp.status_code == 200
    assert resp_json["total"] == 5
    assert resp_json["imageNumber"] == 3


@patch.object(AuthUser, "auth", return_value="user", autospec=True)
def test_get_forbidden(mock_user, client):
    """Try to get motion correction in a data collection that does not belong to user"""
    resp = client.get("/dataCollections/6017406/motion")
    assert resp.status_code == 403
