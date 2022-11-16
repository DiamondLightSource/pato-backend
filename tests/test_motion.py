from unittest.mock import patch

from ebic.utils import auth


@patch.object(auth, "get_user", return_value={"id": "admin"}, autospec=True)
def test_get_admin(mock_user, client):
    """Get motion correction in a tomogram (request for admin)"""
    resp = client.get("/motion/1")
    resp_json = resp.json()

    assert resp.status_code == 200
    assert resp_json["total"] == 4
    assert resp_json["rawTotal"] == 5


@patch.object(auth, "get_user", return_value={"id": "em_admin"}, autospec=True)
def test_get_em_admin(mock_user, client):
    """Get motion correction in a tomogram (request for EM admin).
    Non-EM tomograms cannot exist."""
    resp = client.get("/motion/1")
    assert resp.status_code == 200
    assert resp.json()["total"] == 4


@patch.object(auth, "get_user", return_value={"id": "user"}, autospec=True)
def test_get_user(mock_user, client):
    """Get all motion correction in a tomogram belonging to user"""
    resp = client.get("/motion/2")
    assert resp.status_code == 200
    assert resp.json()["total"] == 4


@patch.object(auth, "get_user", return_value={"id": "user"}, autospec=True)
def test_get_forbidden(mock_user, client):
    """Try to get motion correction in a tomogram that does not belong to user"""
    resp = client.get("/motion/1")
    assert resp.status_code == 403
