import pytest

from .users import admin, em_admin, user


@pytest.mark.parametrize("override_user", [admin], indirect=True)
def test_get_admin(override_user, client):
    """Get all data collection groups in a visit (request for admin)"""
    resp = client.get("/dataCollectionGroups?visit=27464088")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@pytest.mark.parametrize("override_user", [em_admin], indirect=True)
def test_get_em_admin(override_user, client):
    """Get all collection groups in visit belonging to EM (request for EM admin)"""
    resp = client.get("/dataCollectionGroups?visit=27464088")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@pytest.mark.parametrize("override_user", [em_admin], indirect=True)
def test_get_non_em(override_user, client):
    """Try to get all collection groups belonging to a non-EM visit (request for EM
    admin)"""
    resp = client.get("/dataCollectionGroups?visit=55168")
    assert resp.status_code == 404


@pytest.mark.parametrize("override_user", [user], indirect=True)
def test_get_user(override_user, client):
    """Get data collection groups in a visit belonging to a regular user"""
    resp = client.get("/dataCollectionGroups?visit=27464089")
    assert resp.status_code == 200
    assert resp.json()["total"] == 4


@pytest.mark.parametrize("override_user", [user], indirect=True)
def test_get_forbidden(override_user, client):
    """Try to get data collection groups for a visit that does not belong to user"""
    resp = client.get("/dataCollectionGroups?visit=27464088")
    assert resp.status_code == 404


@pytest.mark.parametrize("override_user", [admin], indirect=True)
def test_get_collection_count(override_user, client):
    """Get count of collections that belong to a data collection group"""
    resp = client.get("/dataCollectionGroups?visit=27464089")
    resp_json = resp.json()

    assert resp.status_code == 200
    assert resp_json["items"][1]["collections"] == 1
    assert resp_json["items"][2]["collections"] == 2
