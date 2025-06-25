def test_get(mock_permissions, client):
    """Should get all data collection attachments"""
    resp = client.get("/dataCollections/6017413/attachments")
    assert resp.status_code == 200

    assert len(resp.json()["items"]) == 2


def test_get_by_file_type(mock_permissions, client):
    """Should get all data collection attachments with a specific file type"""
    resp = client.get("/dataCollections/6017413/attachments?fileType=params")
    assert resp.status_code == 200

    assert len(resp.json()["items"]) == 1
