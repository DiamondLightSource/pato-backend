def test_get_user(mock_permissions, client):
    """Get particle picking data for an autoprocessing program"""
    resp = client.get("/autoProc/56986680/classification?classType=3d")
    assert resp.status_code == 200
    assert resp.json()["total"] == 3


def test_sort_particles(mock_permissions, client):
    """Get particle picking data for an autoprocessing program and sort by particles
    per class"""
    resp = client.get("/autoProc/56986680/classification?classType=3d")
    assert resp.status_code == 200
    assert resp.json()["items"][0]["particlesPerClass"] == 60000


def test_sort_class(mock_permissions, client):
    """Get particle picking data for an autoprocessing program and sort by
    class distribution"""
    resp = client.get("/autoProc/56986680/classification?sortBy=class&classType=3d")
    assert resp.status_code == 200
    assert resp.json()["items"][0]["classDistribution"] == 0.3


def test_sort_resolution(mock_permissions, client):
    """Get particle picking data for an autoprocessing program and sort by estimated
    resolution"""
    resp = client.get(
        "/autoProc/56986680/classification?sortBy=resolution&classType=3d"
    )
    assert resp.status_code == 200
    assert resp.json()["items"][0]["estimatedResolution"] == 15
