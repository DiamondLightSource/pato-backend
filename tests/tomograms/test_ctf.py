def test_get_user(mock_permissions, client):
    """Get CTF data in a tomogram belonging to user"""
    resp = client.get("/tomograms/1/ctf")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 4
