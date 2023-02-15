def test_get_user(mock_permissions, client):
    """Get estimated resolution frequency data for an autoprocessing program"""
    resp = client.get("/autoProc/56986680/resolution?dataBin=5")
    assert resp.status_code == 200
    assert resp.json()["items"][2]["x"] == 5
    assert resp.json()["items"][2]["y"] == 3


def test_get_minimum(mock_permissions, client):
    """Get estimated resolution frequency data for an autoprocessing program with a
    minimum bin"""
    resp = client.get("/autoProc/56986680/resolution?minimum=900")
    assert resp.status_code == 200
    assert resp.json()["items"][0]["x"] == "<900.0"
    assert resp.json()["items"][0]["y"] == 5


def test_not_found(mock_permissions, client):
    """Get estimated resolution frequency data for an autoprocessing program that does
    not exist"""
    resp = client.get("/dataCollections/99999999/resolution?dataBin=1")
    assert resp.status_code == 404
