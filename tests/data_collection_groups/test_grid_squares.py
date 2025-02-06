def test_get(mock_permissions, client):
    """Get grid squares in data collection group"""
    resp = client.get("/dataGroups/5440742/grid-squares")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 1

def test_get_empty(mock_permissions, client):
    """Get all grid squares (including uncollected)"""
    resp = client.get("/dataGroups/5440742/grid-squares", params="hideUncollected=false")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 2
