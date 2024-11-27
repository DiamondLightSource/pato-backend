def test_get(mock_permissions, client):
    """Get foil holes belonging to grid square"""
    resp = client.get("/foil-holes/1/movies")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 1
