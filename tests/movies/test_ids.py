def test_get_movie_info(mock_permissions, client):
    """Get foil hole and grid square IDs for a given movie"""
    resp = client.get("/movies/27")
    assert resp.status_code == 200
    assert resp.json()["foilHoleId"] == 1
    assert resp.json()["gridSquareId"] == 1

def test_inexistent(mock_permissions, client):
    """Should raise exception if movie not in database"""
    resp = client.get("/movies/9999")
    assert resp.status_code == 404
