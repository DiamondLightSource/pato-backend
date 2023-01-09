import pytest


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_get_user(mock_permissions, client):
    """Get CTF data in a tomogram belonging to user"""
    resp = client.get("/tomograms/1/ctf")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 4


@pytest.mark.parametrize("mock_permissions", [403], indirect=True)
def test_get_forbidden(mock_permissions, client):
    """Try to get CTF data in a tomogram that does not belong to user"""
    resp = client.get("/tomograms/1/ctf")
    assert resp.status_code == 403
