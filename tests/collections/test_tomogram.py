def test_get(mock_permissions, client):
    """Get tomogram in a data collection belonging to user"""
    resp = client.get("/dataCollections/6017408/tomograms")
    assert resp.status_code == 200


def test_get_list(mock_permissions, client):
    """Get multiple tomograms for one given data collection"""
    resp = client.get("/dataCollections/6017411/tomograms")
    assert resp.status_code == 200
    assert resp.json()["total"] == 2
