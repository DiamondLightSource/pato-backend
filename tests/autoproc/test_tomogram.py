def test_get(mock_permissions, client):
    """Get tomogram in an autoprocessing program"""
    resp = client.get("/autoProc/56986800/tomogram")
    assert resp.status_code == 200


def test_not_found(mock_permissions, client):
    """Get tomogram in an autoprocessing program with no tomograms"""
    resp = client.get("/autoProc/56425592/tomogram")
    assert resp.status_code == 404
