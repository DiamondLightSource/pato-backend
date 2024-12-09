def test_get(mock_permissions, client):
    """Get atlas belonging to data collection group"""
    resp = client.get("/dataGroups/5440742/atlas")
    assert resp.status_code == 200
    assert resp.json()["pixelSize"] == 1


def test_get_no_atlas(mock_permissions, client):
    """Should return 404 if data collection group has no atlas"""
    resp = client.get("/dataGroups/996311/atlas")
    assert resp.status_code == 404
