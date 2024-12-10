import pytest

from ..users import admin, em_admin, user


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_get_admin(mock_user, client):
    """Get all data collection groups in a visit (request for admin)"""
    resp = client.get("/dataGroups?proposal=cm31111&session=5")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@pytest.mark.parametrize("mock_user", [em_admin], indirect=True)
def test_get_em_admin(mock_user, client):
    """Get all collection groups in visit belonging to EM (request for EM admin)"""
    resp = client.get("/dataGroups?proposal=cm31111&session=5")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@pytest.mark.parametrize("mock_user", [em_admin], indirect=True)
def test_get_non_em(mock_user, client):
    """Try to get all collection groups belonging to a non-EM visit (request for EM
    admin)"""
    resp = client.get("/dataGroups?proposal=cm14451&session=1")
    assert len(resp.json()["items"]) == 0


@pytest.mark.parametrize("mock_user", [user], indirect=True)
def test_get_user(mock_user, client):
    """Get data collection groups in a visit belonging to a regular user"""
    resp = client.get("/dataGroups?proposal=cm31111&session=6")
    assert resp.status_code == 200
    assert resp.json()["total"] == 4


@pytest.mark.parametrize("mock_user", [user], indirect=True)
def test_get_forbidden(mock_user, client):
    """Try to get data collection groups for a visit that does not belong to user"""
    resp = client.get("/dataGroups?proposal=cm31111&session=5")
    assert len(resp.json()["items"]) == 0


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_get_collection_count(mock_user, client):
    """Get count of collections that belong to a data collection group"""
    resp = client.get("/dataGroups?proposal=cm31111&session=6")
    resp_json = resp.json()

    assert resp.status_code == 200
    assert resp_json["items"][1]["collections"] == 1
    assert resp_json["items"][2]["collections"] == 2
