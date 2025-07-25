def test_get(mock_permissions, client):
    """Get tomograms in grid square"""
    resp = client.get("/grid-squares/1/tomograms")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 2
