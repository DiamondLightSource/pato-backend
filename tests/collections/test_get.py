def test_get(mock_permissions, client):
    """Get data collection"""
    resp = client.get("/dataCollections/6017412")
    assert resp.status_code == 200
    assert resp.json()["index"] == 2
