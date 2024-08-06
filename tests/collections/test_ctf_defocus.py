def test_get(mock_permissions, client):
    """Get defocus/particle count data for data collection"""
    resp = client.get("/dataCollections/6017412/ctf")
    assert resp.status_code == 200
    assert resp.json()["items"][0]["x"] == 5
    assert resp.json()["items"][0]["y"] == 10
