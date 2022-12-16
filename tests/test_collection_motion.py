import pytest


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_get_user(mock_permissions, client):
    """Get all motion correction in a data collection belonging to user"""
    resp = client.get("/dataCollections/6017408/motion")
    assert resp.status_code == 200
    assert resp.json()["total"] == 5


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_nth_motion(mock_permissions, client):
    """Get specific (nth) motion correction"""
    resp = client.get("/dataCollections/6017408/motion?page=2&limit=1")
    resp_json = resp.json()

    assert resp.status_code == 200
    assert resp_json["total"] == 5
    assert resp_json["items"][0]["MotionCorrection"]["imageNumber"] == 3


@pytest.mark.parametrize("mock_permissions", [403], indirect=True)
def test_get_forbidden(mock_permissions, client):
    """Try to get motion correction in a data collection that does not belong to user"""
    resp = client.get("/dataCollections/6017406/motion")
    assert resp.status_code == 403
