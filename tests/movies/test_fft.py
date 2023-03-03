from unittest.mock import patch

from ..conftest import mock_send


def test_get(mock_permissions, client):
    """Get theoretical FFT for motion correction"""
    with patch("pato.routes.movies.FileResponse.__call__", new=mock_send):
        resp = client.get("/movies/1/fft")
    assert resp.status_code == 200


def test_inexistent_file(mock_permissions, client):
    """Try to get theoretical FFT for CTF not in database"""
    with patch("pato.routes.movies.FileResponse.__call__", new=mock_send):
        resp = client.get("/movies/221/fft")
    assert resp.status_code == 404
