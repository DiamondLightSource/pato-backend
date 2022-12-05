import pytest

from .users import admin, em_admin, user


@pytest.mark.parametrize("override_user", [admin], indirect=True)
def test_get_admin(override_user, client):
    """Get theoretical FFT for motion correction (request for admin)"""
    resp = client.get("/image/fft/1")
    assert resp.status_code == 200


@pytest.mark.parametrize("override_user", [em_admin], indirect=True)
def test_get_em_admin(override_user, client):
    """Get theoretical FFT for motion correction (request for EM admin)."""
    resp = client.get("/image/fft/1")
    assert resp.status_code == 200


@pytest.mark.parametrize("override_user", [user], indirect=True)
def test_get_user(override_user, client):
    """Get all theoretical FFT for motion correction belonging to user"""
    resp = client.get("/image/fft/15")
    assert resp.status_code == 200


@pytest.mark.parametrize("override_user", [user], indirect=True)
def test_get_forbidden(override_user, client):
    """Get all theoretical FFT for motion correction not belonging to user"""
    resp = client.get("/image/fft/1")
    assert resp.status_code == 403


@pytest.mark.parametrize("override_user", [admin], indirect=True)
def test_file_not_found(override_user, exists_mock, client):
    """Try to get image file that does not exist"""
    exists_mock.return_value = False
    resp = client.get("/image/fft/1")
    assert resp.status_code == 404


@pytest.mark.parametrize("override_user", [admin], indirect=True)
def test_inexistent_file(override_user, client):
    """Try to get theoretical FFT for CTF not in database"""
    resp = client.get("/image/fft/221")
    assert resp.status_code == 404
