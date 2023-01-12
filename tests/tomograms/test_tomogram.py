def test_get_user(mock_permissions, client):
    """Get tomogram in a data collection belonging to user"""
    resp = client.get("/dataCollections/6017408/tomogram")
    assert resp.status_code == 200
