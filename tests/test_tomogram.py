def test_tomogram(client):
    resp = client.get("/tomograms/6017406")
    assert resp.status_code == 200


def test_no_tomogram(client):
    resp = client.get("/tomograms/1")
    assert resp.status_code == 404
