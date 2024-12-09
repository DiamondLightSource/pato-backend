def test_get(mock_permissions, client):
    """Get foil holes belonging to grid square"""
    resp = client.get("/grid-squares/1/foil-holes")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 1
