def test_get(mock_permissions, client):
    """Get data collection groups in proposal"""
    resp = client.get("/proposals/cm14451/data-collection-groups")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 6
