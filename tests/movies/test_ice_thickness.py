from unittest.mock import patch

from ..conftest import mock_send


def test_get(mock_permissions, client):
    """Get ice thickness data for a given movie"""
    with patch("ebic.routes.movies.FileResponse.__call__", new=mock_send):
        resp = client.get("/movies/25/iceThickness")
    assert resp.status_code == 200
    assert resp.json()["current"]["minimum"] == 3


def test_get_average(mock_permissions, client):
    """Get ice thickness data for a given movie wtih averages"""
    with patch("ebic.routes.movies.FileResponse.__call__", new=mock_send):
        resp = client.get("/movies/25/iceThickness?getAverages=true")
    assert resp.status_code == 200
    assert resp.json()["current"]["minimum"] == 3
    assert resp.json()["avg"]["minimum"] == 2
