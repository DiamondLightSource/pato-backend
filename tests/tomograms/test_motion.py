def test_get(mock_permissions, client):
    """Get motion correction in a tomogram (request for admin)"""
    resp = client.get("/tomograms/1/motion")
    resp_json = resp.json()

    assert resp.status_code == 200
    assert resp_json["total"] == 4
    assert resp_json["rawTotal"] == 5


def test_get_middle(mock_permissions, client):
    """Get motion correction without tilt alignment data"""
    resp = client.get("/tomograms/1/motion?getMiddle=true")
    assert resp.status_code == 200
    assert resp.json()["items"][0]["TiltImageAlignment"]["refinedTiltAngle"] == 17


def test_no_tilt_alignment(mock_permissions, client):
    """Get motion correction without tilt alignment data"""
    resp = client.get("/tomograms/3/motion")
    motion_correction = resp.json()

    assert resp.status_code == 200
    assert motion_correction["total"] == 0


def test_nth_motion(mock_permissions, client):
    """Get specific motion correction"""
    resp = client.get("/tomograms/2/motion?page=1&limit=1")
    resp_json = resp.json()

    assert resp.status_code == 200
    assert resp_json["total"] == 4
    assert resp_json["items"][0]["TiltImageAlignment"]["refinedTiltAngle"] == 17
