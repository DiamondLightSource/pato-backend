def test_get(mock_permissions, client):
    """Get session"""
    resp = client.get("/proposals/cm14451/sessions/1")
    assert resp.status_code == 200
    assert resp.json()["sessionId"] == 55167


def test_get_inexistent(mock_permissions, client):
    """Raise error if session does not exist"""
    resp = client.get("/proposals/cm14451/sessions/0")
    assert resp.status_code == 404
