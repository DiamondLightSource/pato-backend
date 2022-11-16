from unittest.mock import patch

from ebic.utils import auth


@patch.object(auth, "get_user", return_value={"id": "admin"}, autospec=True)
def test_get_admin(mock_user, client):
    """Get all tomograms in a data collection (request for admin)"""
    resp = client.get("/tomograms/6017406")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@patch.object(auth, "get_user", return_value={"id": "em_admin"}, autospec=True)
def test_get_em_admin(mock_user, client):
    """Get tomogram in a data collection (request for EM admin).
    Non-EM tomograms cannot exist."""
    resp = client.get("/tomograms/6017406")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@patch.object(auth, "get_user", return_value={"id": "user"}, autospec=True)
def test_get_user(mock_user, client):
    """Get all tomograms in a data collection belonging to user"""
    resp = client.get("/tomograms/6017408")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@patch.object(auth, "get_user", return_value={"id": "user"}, autospec=True)
def test_get_forbidden(mock_user, client):
    """Try to get tomograms in a data collection that does not belong to user"""
    resp = client.get("/tomograms/6017406")
    assert resp.status_code == 403
