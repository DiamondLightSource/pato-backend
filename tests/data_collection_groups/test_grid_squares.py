def test_get(mock_permissions, client):
    """Get all grid squares in data collection group (including uncollected)"""
    resp = client.get("/dataGroups/5440742/grid-squares")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 2

def test_get_empty(mock_permissions, client):
    """Get only collected grid squares"""
    resp = client.get("/dataGroups/5440742/grid-squares", params="hideUncollected=true")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 1
