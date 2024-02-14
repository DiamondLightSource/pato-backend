def test_get(mock_permissions, client):
    """Get all processing job parameters for job"""
    resp = client.get("/processingJob/5/parameters")
    assert resp.status_code == 200
    assert resp.json() == {
        "items": {"vortex factor": "1.8*10^102", "80s factor": "0.87*10^-93"},
    }


def test_inexistent(mock_permissions, client):
    """Try to get processing job parameters for job that doesn't exist"""
    resp = client.get("/processingJob/0/parameters")
    assert resp.status_code == 404
