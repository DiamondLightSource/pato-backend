from unittest.mock import patch

from ..conftest import mock_send


def test_get(mock_permissions, client):
    """Get atlas image belonging to data collection group"""
    with patch("pato.routes.movies.FileResponse.__call__", new=mock_send):
        resp = client.get("/dataGroups/5440742/atlas/image")
    assert resp.status_code == 200


def test_get_no_atlas(mock_permissions, client):
    """Should return 404 if data collection group has no atlas"""
    resp = client.get("/dataGroups/996311/atlas/image")
    assert resp.status_code == 404
