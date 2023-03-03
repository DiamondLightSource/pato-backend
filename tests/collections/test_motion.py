def test_get_user(mock_permissions, client):
    """Get all motion correction in a data collection belonging to user"""
    resp = client.get("/dataCollections/6017408/motion")
    assert resp.status_code == 200
    assert resp.json()["total"] == 5


def test_nth_motion(mock_permissions, client):
    """Get specific (nth) motion correction"""
    resp = client.get("/dataCollections/6017408/motion?page=2&limit=1")
    resp_json = resp.json()

    assert resp.status_code == 200
    assert resp_json["total"] == 5
    assert resp_json["items"][0]["MotionCorrection"]["imageNumber"] == 3
