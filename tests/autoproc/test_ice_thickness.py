def test_get_user(mock_permissions, client):
    """Get ice thickness frequency data for an autoprocessing program"""
    resp = client.get("/autoProc/56986680/iceThickness?dataBin=1")
    assert resp.status_code == 200
    assert resp.json()["items"][0]["y"] == 2
    assert resp.json()["items"][1]["y"] == 1


def test_not_found(mock_permissions, client):
    """Get ice thickness frequency data for an autoprocessing program that does not
    exist"""
    resp = client.get("/autoProc/99999999/iceThickness?dataBin=1")
    assert resp.status_code == 404
