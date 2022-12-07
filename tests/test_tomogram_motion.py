import pytest


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_get_admin(mock_permissions, client):
    """Get motion correction in a tomogram (request for admin)"""
    resp = client.get("/tomograms/1/motion")
    resp_json = resp.json()

    assert resp.status_code == 200
    assert resp_json["total"] == 4
    assert resp_json["rawTotal"] == 5


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_no_tilt_alignment(mock_permissions, client):
    """Get motion correction without tilt alignment data"""
    resp = client.get("/tomograms/3/motion")
    assert resp.status_code == 404


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_nth_motion(mock_permissions, client):
    """Get specific (nth) motion correction"""
    resp = client.get("/tomograms/2/motion?nth=2")
    resp_json = resp.json()

    assert resp.status_code == 200
    assert resp_json["total"] == 4
    assert resp_json["refinedTiltAngle"] == 17


@pytest.mark.parametrize("mock_permissions", [403], indirect=True)
def test_get_forbidden(mock_permissions, client):
    """Try to get motion correction in a tomogram that does not belong to user"""
    resp = client.get("/tomograms/1/motion")
    assert resp.status_code == 403
