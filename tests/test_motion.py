from unittest.mock import patch
from ebic.utils.auth import AuthUser


@patch.object(AuthUser, "auth", return_value="admin", autospec=True)
def test_get_admin(mock_user, client):
    """Get motion correction in a tomogram (request for admin)"""
    resp = client.get("/motion/1")
    resp_json = resp.json()

    assert resp.status_code == 200
    assert resp_json["total"] == 4
    assert resp_json["rawTotal"] == 5


@patch.object(AuthUser, "auth", return_value="em_admin", autospec=True)
def test_get_em_admin(mock_user, client):
    """Get motion correction in a tomogram (request for EM admin).
    Non-EM tomograms cannot exist."""
    resp = client.get("/motion/1")
    assert resp.status_code == 200
    assert resp.json()["total"] == 4


@patch.object(AuthUser, "auth", return_value="user", autospec=True)
def test_get_user(mock_user, client):
    """Get all motion correction in a tomogram belonging to user"""
    resp = client.get("/motion/2")
    assert resp.status_code == 200
    assert resp.json()["total"] == 4


@patch.object(AuthUser, "auth", return_value="user", autospec=True)
def test_no_tilt_alignment(mock_user, client):
    """Get motion correction without tilt alignment data"""
    resp = client.get("/motion/3")
    resp_json = resp.json()

    assert resp.status_code == 200
    assert resp_json["total"] == 0
    assert resp_json["rawTotal"] == 5


@patch.object(AuthUser, "auth", return_value="user", autospec=True)
def test_nth_motion(mock_user, client):
    """Get specific (nth) motion correction"""
    resp = client.get("/motion/2?nth=2")
    resp_json = resp.json()

    assert resp.status_code == 200
    assert resp_json["total"] == 4
    assert resp_json["refinedTiltAngle"] == 17


@patch.object(AuthUser, "auth", return_value="user", autospec=True)
def test_get_forbidden(mock_user, client):
    """Try to get motion correction in a tomogram that does not belong to user"""
    resp = client.get("/motion/1")
    assert resp.status_code == 403
