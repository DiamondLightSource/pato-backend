def test_get_user(mock_permissions, client):
    """Get B factor fit data for an autoprocessing program"""
    resp = client.get("/autoProc/56986680/bFactorFit")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 1


def test_get_minimum(mock_permissions, client):
    """Get B Factor fit data for an autoprocessing program that does not have
    B factor fit data"""
    resp = client.get("/autoProc/56425592/bFactorFit")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 0
