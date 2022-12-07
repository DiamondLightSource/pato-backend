import pytest


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_get_admin(mock_permissions, client):
    """Get theoretical FFT for motion correction"""
    resp = client.get("/image/fft/1")
    assert resp.status_code == 200


@pytest.mark.parametrize("mock_permissions", [403], indirect=True)
def test_get_forbidden(mock_permissions, client):
    """Get all theoretical FFT for motion correction not belonging to user"""
    resp = client.get("/image/fft/1")
    assert resp.status_code == 403


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_inexistent_file(mock_permissions, client):
    """Try to get theoretical FFT for CTF not in database"""
    resp = client.get("/image/fft/221")
    assert resp.status_code == 404
