def test_get(mock_permissions, client):
    """Get particle count sum per resolution for data collection"""
    resp = client.get("/dataCollections/6017412/particleCountPerResolution")
    assert resp.status_code == 200
    assert resp.json()["items"][5]["x"] == 5
    assert resp.json()["items"][5]["y"] == 90

def test_get_no_items(mock_permissions, client):
    """Should return 404 if no resolution/particle count data is available"""
    resp = client.get("/dataCollections/6017406/particleCountPerResolution")
    assert resp.status_code == 404

