from unittest.mock import patch

from ..conftest import mock_send


def test_get(mock_permissions, client):
    """Get atlas image belonging to data collection group"""
    with patch("pato.routes.movies.FileResponse.__call__", new=mock_send):
        resp = client.get("/dataGroups/5440742/atlas/image")
    assert resp.status_code == 200


def test_get_colour(mock_permissions, exists_mock, client):
    """Get image of colour channel for atlas"""
    with patch("pato.routes.movies.FileResponse.__call__", new=mock_send):
        resp = client.get("/dataGroups/1040398/atlas/image?colour=blue")
    assert resp.status_code == 200
    exists_mock.assert_called_with("/dls/blue.png")

def test_get_colour_not_provided(mock_permissions, client):
    """Should raise error if colour is not provided and path is a glob pattern"""
    resp = client.get("/dataGroups/1040398/atlas/image?colour=null")
    assert resp.status_code == 422

def test_get_colour_grey(mock_permissions, exists_mock, client):
    """Get image of colour channel for atlas (with american spelling)"""
    with patch("pato.routes.movies.FileResponse.__call__", new=mock_send):
        resp = client.get("/dataGroups/1040398/atlas/image?colour=grey")
    assert resp.status_code == 200
    exists_mock.assert_called_with("/dls/gray.png")


def test_get_no_atlas(mock_permissions, client):
    """Should return 404 if data collection group has no atlas"""
    resp = client.get("/dataGroups/996311/atlas/image")
    assert resp.status_code == 404


def test_file_not_found(mock_permissions, exists_mock, client):
    """Try to get image file that does not exist"""
    exists_mock.return_value = False
    resp = client.get("/dataGroups/996311/atlas/image")
    assert resp.status_code == 404
