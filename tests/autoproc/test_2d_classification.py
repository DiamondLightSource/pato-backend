import pytest


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_get_user(mock_permissions, client):
    """Get particle picking data for an autoprocessing program"""
    resp = client.get("/autoProc/56986680/classification/2d")
    print(resp.json())
    assert resp.status_code == 200
    assert resp.json()["total"] == 3


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_sort_particles(mock_permissions, client):
    """Get particle picking data for an autoprocessing program"""
    resp = client.get("/autoProc/56986680/classification/2d")
    print(resp.json())
    assert resp.status_code == 200
    assert resp.json()["items"][0]["particlesPerClass"] == 60000


@pytest.mark.parametrize("mock_permissions", [403], indirect=True)
def test_get_forbidden(mock_permissions, client):
    """Try to get particle picking data for an autoprocessing program where the user is
    not present in the parent session"""
    resp = client.get("/autoProc/56986680/classification/2d")
    assert resp.status_code == 403
