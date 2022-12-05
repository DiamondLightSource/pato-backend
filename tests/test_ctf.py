import pytest

from .users import admin, em_admin, user


@pytest.mark.parametrize("override_user", [admin], indirect=True)
def test_get_admin(override_user, client):
    """Get CTF data in a tomogram (request for admin)"""
    resp = client.get("/tomograms/1/ctf")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 4


@pytest.mark.parametrize("override_user", [em_admin], indirect=True)
def test_get_em_admin(override_user, client):
    """Get CTF data in a tomogram (request for EM admin).
    Non-EM tomograms cannot exist."""
    resp = client.get("/tomograms/1/ctf")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 4


@pytest.mark.parametrize("override_user", [user], indirect=True)
def test_get_user(override_user, client):
    """Get CTF data in a tomogram belonging to user"""
    resp = client.get("/tomograms/2/ctf")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 4


@pytest.mark.parametrize("override_user", [user], indirect=True)
def test_get_forbidden(override_user, client):
    """Try to get CTF data in a tomogram that does not belong to user"""
    resp = client.get("/tomograms/1/ctf")
    assert resp.status_code == 403
