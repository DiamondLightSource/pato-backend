import pytest

from .users import admin, em_admin, user


@pytest.mark.parametrize("override_user", [admin], indirect=True)
def test_get_admin(override_user, client):
    """Get central slice for tomogram (request for admin)"""
    resp = client.get("/tomograms/1/centralSlice")
    assert resp.status_code == 200


@pytest.mark.parametrize("override_user", [em_admin], indirect=True)
def test_get_em_admin(override_user, client):
    """Get central slice for tomogram (request for EM admin)."""
    resp = client.get("/tomograms/1/centralSlice")
    assert resp.status_code == 200


@pytest.mark.parametrize("override_user", [user], indirect=True)
def test_get_user(override_user, client):
    """Get all central slice for tomogram belonging to user"""
    resp = client.get("/tomograms/2/centralSlice")
    assert resp.status_code == 200


@pytest.mark.parametrize("override_user", [user], indirect=True)
def test_get_forbidden(override_user, client):
    """Get all central slice for tomogram not belonging to user"""
    resp = client.get("/tomograms/1/centralSlice")
    assert resp.status_code == 403


@pytest.mark.parametrize("override_user", [admin], indirect=True)
def test_file_not_found(override_user, exists_mock, client):
    """Try to get image file that does not exist"""
    exists_mock.return_value = False
    resp = client.get("/tomograms/1/centralSlice")
    assert resp.status_code == 404


@pytest.mark.parametrize("override_user", [admin], indirect=True)
def test_inexistent_file(override_user, client):
    """Try to get central slice for tomogram not in database"""
    resp = client.get("/tomograms/221/centralSlice")
    assert resp.status_code == 404
