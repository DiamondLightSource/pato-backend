import pytest


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_get_user(mock_permissions, client):
    """Get particle picking data for an autoprocessing program"""
    resp = client.get("/autoProc/56986680/classification/2d")
    print(resp.json())
    assert resp.status_code == 200
    assert resp.json()["total"] == 5


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_sort_particles(mock_permissions, client):
    """Get particle picking data for an autoprocessing program and sort by particles
    per class"""
    resp = client.get("/autoProc/56986680/classification/2d")
    print(resp.json())
    assert resp.status_code == 200
    assert resp.json()["items"][0]["particlesPerClass"] == 60000


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_sort_class(mock_permissions, client):
    """Get particle picking data for an autoprocessing program and sort by
    class distribution"""
    resp = client.get("/autoProc/56986680/classification/2d?sortBy=class")
    print(resp.json())
    assert resp.status_code == 200
    assert resp.json()["items"][0]["classDistribution"] == 0.3


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_sort_resolution(mock_permissions, client):
    """Get particle picking data for an autoprocessing program and sort by estimated
    resolution"""
    resp = client.get("/autoProc/56986680/classification/2d?sortBy=resolution")
    print(resp.json())
    assert resp.status_code == 200
    assert resp.json()["items"][0]["estimatedResolution"] == 18


@pytest.mark.parametrize("mock_permissions", [403], indirect=True)
def test_get_forbidden(mock_permissions, client):
    """Try to get particle picking data for an autoprocessing program where the user is
    not present in the parent session"""
    resp = client.get("/autoProc/56986680/classification/2d")
    assert resp.status_code == 403
