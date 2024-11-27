def test_get(mock_permissions, client):
    """Get grid squares in data collection group"""
    resp = client.get("/dataGroups/5440742/grid-squares")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 1
