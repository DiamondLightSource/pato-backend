def test_get(mock_permissions, client):
    """Get tomogram in a data collection belonging to user"""
    resp = client.get("/dataCollections/6017408/tomograms")
    assert resp.status_code == 200


def test_get_list(mock_permissions, client):
    """Get multiple tomograms for one given data collection"""
    resp = client.get("/dataCollections/6017411/tomograms")
    assert resp.status_code == 200
    assert resp.json()["total"] == 2


def test_get_no_tomogram(mock_permissions, client):
    """Get processing job with no associated tomogram"""
    resp = client.get("/dataCollections/6017413/tomograms")
    assert resp.status_code == 200
    assert resp.json()["items"][1]["Tomogram"] is None
