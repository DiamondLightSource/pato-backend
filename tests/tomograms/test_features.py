def test_get(mock_permissions, client):
    """Get tomogram features"""
    resp = client.get("/tomograms/3/features")
    assert resp.status_code == 200

    assert len(resp.json()["features"]) == 3

def test_no_features(mock_permissions, client):
    """Should return empty array if tomogram has no features"""
    resp = client.get("/tomograms/1/features")
    assert resp.status_code == 200

    assert len(resp.json()["features"]) == 0
