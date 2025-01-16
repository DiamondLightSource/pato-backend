from ..conftest import mock_send


def test_get_movie_info(mock_permissions, client):
    """Get foil hole and grid square IDs for a given movie"""
      resp = client.get("/movies/27")
    assert resp.status_code == 200
    assert resp.json()["foilHoleId"] == 1
    assert resp.json()["gridSquareId"] == 1

