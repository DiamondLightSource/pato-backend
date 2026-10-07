import pytest

from ..users import admin


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_get(mock_user, mock_permissions, client):
    """Get session"""
    resp = client.get("/proposals/cm14451/sessions/1")
    assert resp.status_code == 200
    assert resp.json()["sessionId"] == 55167


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_get_inexistent(mock_user, mock_permissions, client):
    """Raise error if session does not exist"""
    resp = client.get("/proposals/cm14451/sessions/0")
    assert resp.status_code == 404
