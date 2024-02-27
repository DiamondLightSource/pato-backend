def test_get_user(mock_permissions, client):
    """Get CTF data for a given autoprocessing program"""
    resp = client.get("/autoProc/56986680/ctf")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 3
