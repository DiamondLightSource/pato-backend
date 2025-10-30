def test_get(mock_permissions, client):
    """Get motion correction in a tomogram (request for admin)"""
    resp = client.get("/dataCollections/6017406/tomogram-motion")
    resp_json = resp.json()

    assert resp.status_code == 200
    assert resp_json["total"] == 5
    assert resp_json["alignedTotal"] == 5


def test_get_middle(mock_permissions, client):
    """Get central slice"""
    resp = client.get("/dataCollections/6017406/tomogram-motion?getMiddle=true")
    assert resp.status_code == 200
    assert resp.json()["items"][0]["TiltImageAlignment"]["refinedTiltAngle"] == 16


def test_no_tilt_alignment(mock_permissions, client):
    """Get motion correction without tilt alignment data"""
    resp = client.get("/dataCollections/6017411/tomogram-motion")

    assert resp.status_code == 200

    motion_correction = resp.json()
    assert motion_correction["total"] == 5
    assert motion_correction["alignedTotal"] == 0


def test_nth_motion(mock_permissions, client):
    """Get specific motion correction"""
    resp = client.get("/dataCollections/6017408/tomogram-motion?page=1&limit=1")

    assert resp.status_code == 200

    motion_correction = resp.json()

    assert motion_correction["total"] == 6
    assert motion_correction["items"][0]["TiltImageAlignment"]["refinedTiltAngle"] == 18
