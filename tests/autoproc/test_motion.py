import pytest


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_get_user(mock_permissions, client):
    """Get all motion correction in an autoprocessing program belonging to user"""
    resp = client.get("/autoProc/56986680/motion")
    assert resp.status_code == 200
    assert resp.json()["total"] == 5


@pytest.mark.parametrize("mock_permissions", [403], indirect=True)
def test_get_forbidden(mock_permissions, client):
    """Try to get motion correction in an autoprocessing program that does not belong
    to user"""
    resp = client.get("/autoProc/56986680/motion")
    assert resp.status_code == 403
