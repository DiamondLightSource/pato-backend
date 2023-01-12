def test_get_admin(mock_permissions, client):
    """Get all processing jobs for a given collection"""
    resp = client.get("/dataCollections/6017408/processingJobs")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1
