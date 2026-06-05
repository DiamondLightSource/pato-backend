def test_get(mock_permissions, client):
    """Get data collection groups in proposal"""
    resp = client.get("/proposals/cm14451/data-collection-groups")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 6

def test_get_atlas_only(mock_permissions, client):
    """Get data collection groups that have atlases in proposal"""
    resp = client.get("/proposals/cm31111/data-collection-groups")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 5
