def test_get(client):
    """Get data collection group"""
    resp = client.get("/dataGroups/5440744")
    assert resp.status_code == 200
    assert resp.json()["experimentTypeName"] == "Tomography"
