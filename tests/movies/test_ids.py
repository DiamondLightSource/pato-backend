from unittest.mock import patch

from ..conftest import mock_send


def test_get_movie_info(mock_permissions, client):
    """Get foil hole and grid square IDs for a given movie"""
    with patch("pato.routes.movies.FileResponse.__call__", new=mock_send):
        resp = client.get("/movies/27")
    assert resp.status_code == 200
    assert resp.json()["foilHoleId"] == 1
    assert resp.json()["gridSquareId"] == 1

