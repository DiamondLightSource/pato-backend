def test_get_user(mock_permissions, client):
    """Get ice thickness frequency data for a data collection program"""
    resp = client.get("/dataCollections/6017412/iceThickness?dataBin=1")
    assert resp.status_code == 200
    assert resp.json()["items"][0]["y"] == 2
    assert resp.json()["items"][1]["y"] == 1


def test_not_found(mock_permissions, client):
    """Get ice thickness frequency data for a data collection that does not exist"""
    resp = client.get("/dataCollections/99999999/iceThickness?dataBin=1")
    assert resp.status_code == 404
