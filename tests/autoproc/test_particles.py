def test_get_user(mock_permissions, client):
    """Get particle count frequency data for an autoprocessing program"""
    resp = client.get("/autoProc/56986680/particles?dataBin=10")
    assert resp.status_code == 200
    assert resp.json()["items"][2]["x"] == 10
    assert resp.json()["items"][2]["y"] == 1


def test_get_minimum(mock_permissions, client):
    """Get particle count frequency data for an autoprocessing program with a
    minimum bin"""
    resp = client.get("/autoProc/56986680/particles?minimum=900")
    assert resp.status_code == 200
    assert resp.json()["items"][0]["x"] == "<900.0"
    assert resp.json()["items"][0]["y"] == 2


def test_not_found(mock_permissions, client):
    """Get particle count frequency data for an autoprocessing program that does
    not exist"""
    resp = client.get("/autoProc/99999999/particles?dataBin=1")
    assert resp.status_code == 404
