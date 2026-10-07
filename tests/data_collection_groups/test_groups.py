
import pytest

from ..users import admin


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_get(mock_user, mock_permissions, client):
    """Get all data collection groups in a visit"""
    resp = client.get("/proposals/cm31111/sessions/6/dataGroups")
    assert resp.status_code == 200
    assert resp.json()["total"] == 4


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_get_search(mock_user, mock_permissions, client):
    """Get all collection groups filtering by comments"""
    resp = client.get("/proposals/cm31111/sessions/6/dataGroups?search=Processed")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


