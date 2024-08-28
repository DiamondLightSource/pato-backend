def test_get(mock_permissions, client):
    """Get defocus/particle count data for data collection"""
    resp = client.get("/dataCollections/6017412/ctf")
    assert resp.status_code == 200

    items = resp.json()["items"]
    assert items[0]["x"] == 5
    assert items[0]["y"] == 10
    assert len(items) == 1
