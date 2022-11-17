from unittest.mock import patch

from ebic.utils import auth


@patch.object(auth, "get_user", return_value={"id": "admin"}, autospec=True)
def test_get_admin(mock_user, client):
    """Get theoretical FFT for motion correction (request for admin)"""
    resp = client.get("/image/fft/1")
    assert resp.status_code == 200


@patch.object(auth, "get_user", return_value={"id": "em_admin"}, autospec=True)
def test_get_em_admin(mock_user, client):
    """Get theoretical FFT for motion correction (request for EM admin)."""
    resp = client.get("/image/fft/1")
    assert resp.status_code == 200


@patch.object(auth, "get_user", return_value={"id": "user"}, autospec=True)
def test_get_user(mock_user, client):
    """Get all theoretical FFT for motion correction belonging to user"""
    resp = client.get("/image/fft/15")
    assert resp.status_code == 200


@patch.object(auth, "get_user", return_value={"id": "user"}, autospec=True)
def test_get_forbidden(mock_user, client):
    """Get all theoretical FFT for motion correction not belonging to user"""
    resp = client.get("/image/fft/1")
    assert resp.status_code == 403


@patch.object(auth, "get_user", return_value={"id": "admin"}, autospec=True)
def test_file_not_found(mock_user, exists_mock, client):
    """Try to get image file that does not exist"""
    exists_mock.return_value = False
    resp = client.get("/image/fft/1")
    assert resp.status_code == 404


@patch.object(auth, "get_user", return_value={"id": "admin"}, autospec=True)
def test_inexistent_file(mock_user, client):
    """Try to get theoretical FFT for CTF not in database"""
    resp = client.get("/image/fft/221")
    assert resp.status_code == 404
