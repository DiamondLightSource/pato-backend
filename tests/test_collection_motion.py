import pytest

from .users import admin, em_admin, user


@pytest.mark.parametrize("override_user", [admin], indirect=True)
def test_get_admin(override_user, client):
    """Get motion correction in a data collection (request for admin)"""
    resp = client.get("/dataCollections/6017406/motion")
    resp_json = resp.json()

    assert resp.status_code == 200
    assert resp_json["total"] == 5


@pytest.mark.parametrize("override_user", [em_admin], indirect=True)
def test_get_em_admin(override_user, client):
    """Get motion correction in a data collection (request for EM admin)."""
    resp = client.get("/dataCollections/6017406/motion")
    assert resp.status_code == 200
    assert resp.json()["total"] == 5


@pytest.mark.parametrize("override_user", [user], indirect=True)
def test_get_user(override_user, client):
    """Get all motion correction in a data collection belonging to user"""
    resp = client.get("/dataCollections/6017408/motion")
    assert resp.status_code == 200
    assert resp.json()["total"] == 5


@pytest.mark.parametrize("override_user", [user], indirect=True)
def test_nth_motion(override_user, client):
    """Get specific (nth) motion correction"""
    resp = client.get("/dataCollections/6017408/motion?nth=3")
    resp_json = resp.json()

    assert resp.status_code == 200
    assert resp_json["total"] == 5
    assert resp_json["imageNumber"] == 3


@pytest.mark.parametrize("override_user", [user], indirect=True)
def test_get_forbidden(override_user, client):
    """Try to get motion correction in a data collection that does not belong to user"""
    resp = client.get("/dataCollections/6017406/motion")
    assert resp.status_code == 403
