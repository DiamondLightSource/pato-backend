def test_get_user(mock_permissions, client):
    """Get all motion correction in an autoprocessing program belonging to user"""
    resp = client.get("/autoProc/56986680/motion")
    assert resp.status_code == 200
    assert resp.json()["total"] == 5
