from unittest.mock import patch

from ..conftest import mock_send


def test_get(mock_permissions, client):
    """Get image for grid square"""
    with patch("pato.routes.movies.FileResponse.__call__", new=mock_send):
        resp = client.get("/grid-squares/1/image")
    assert resp.status_code == 200

def test_file_not_found(mock_permissions, exists_mock, client):
    """Try to get image file that does not exist"""
    exists_mock.return_value = False
    resp = client.get("/grid-squares/1/image")
    assert resp.status_code == 404
