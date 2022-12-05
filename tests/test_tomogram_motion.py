import pytest

from .users import admin, em_admin, user


@pytest.mark.parametrize("override_user", [admin], indirect=True)
def test_get_admin(override_user, client):
    """Get motion correction in a tomogram (request for admin)"""
    resp = client.get("/tomograms/1/motion")
    resp_json = resp.json()

    assert resp.status_code == 200
    assert resp_json["total"] == 4
    assert resp_json["rawTotal"] == 5


@pytest.mark.parametrize("override_user", [em_admin], indirect=True)
def test_get_em_admin(override_user, client):
    """Get motion correction in a tomogram (request for EM admin).
    Non-EM tomograms cannot exist."""
    resp = client.get("/tomograms/1/motion")
    assert resp.status_code == 200
    assert resp.json()["total"] == 4


@pytest.mark.parametrize("override_user", [user], indirect=True)
def test_get_user(override_user, client):
    """Get all motion correction in a tomogram belonging to user"""
    resp = client.get("/tomograms/2/motion")
    assert resp.status_code == 200
    assert resp.json()["total"] == 4


@pytest.mark.parametrize("override_user", [user], indirect=True)
def test_no_tilt_alignment(override_user, client):
    """Get motion correction without tilt alignment data"""
    resp = client.get("/tomograms/3/motion")
    assert resp.status_code == 404


@pytest.mark.parametrize("override_user", [user], indirect=True)
def test_nth_motion(override_user, client):
    """Get specific (nth) motion correction"""
    resp = client.get("/tomograms/2/motion?nth=2")
    resp_json = resp.json()

    assert resp.status_code == 200
    assert resp_json["total"] == 4
    assert resp_json["refinedTiltAngle"] == 17


@pytest.mark.parametrize("override_user", [user], indirect=True)
def test_get_forbidden(override_user, client):
    """Try to get motion correction in a tomogram that does not belong to user"""
    resp = client.get("/tomograms/1/motion")
    assert resp.status_code == 403
