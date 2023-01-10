import pytest


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_get_user(mock_permissions, client):
    """Get particle picking data for an autoprocessing program"""
    resp = client.get("/autoProc/56986680/particlePicker")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 6


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_get_user(mock_permissions, client):
    """Get particle picking data for an autoprocessing program (filter null
    particle picking rows)"""
    resp = client.get("/autoProc/56986680/particlePicker?filterNull=true")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 2


@pytest.mark.parametrize("mock_permissions", [403], indirect=True)
def test_get_forbidden(mock_permissions, client):
    """Try to get particle picking data for an autoprocessing program where the user is
    not present in the parent session"""
    resp = client.get("/autoProc/56986680/particlePicker")
    assert resp.status_code == 403
