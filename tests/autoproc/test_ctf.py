import pytest


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_get_user(mock_permissions, client):
    """Get CTF data for a given autoprocessing program"""
    resp = client.get("/autoProc/56986680/ctf")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 5


@pytest.mark.parametrize("mock_permissions", [403], indirect=True)
def test_get_forbidden(mock_permissions, client):
    """Try to get CTF data for an autoprocessing program where the user is not present
    in the parent session"""
    resp = client.get("/autoProc/56986680/ctf")
    assert resp.status_code == 403
