from unittest.mock import patch

from ..conftest import mock_send


def test_get(mock_permissions, client):
    """Get micrograph for motion correction"""
    with patch("ebic.routes.movies.FileResponse.__call__", new=mock_send):
        resp = client.get("/movies/1/micrograph")
    assert resp.status_code == 200


def test_file_not_found(mock_permissions, exists_mock, client):
    """Try to get image file that does not exist"""
    exists_mock.return_value = False
    resp = client.get("/movies/1/micrograph")
    assert resp.status_code == 404


def test_inexistent_file(mock_permissions, client):
    """Try to get micrograph for motion correction not in database"""
    resp = client.get("/movies/221/micrograph")
    assert resp.status_code == 404
