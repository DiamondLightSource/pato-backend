def test_get(mock_permissions, client):
    """Get foil holes belonging to grid square"""
    resp = client.get("/grid-squares/1/foil-holes")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 1
    assert resp.json()["items"][0]["movieCount"] == 1


def test_get_metrics(mock_permissions, client):
    """Get average CTF values for foil holes"""
    resp = client.get("/grid-squares/1/foil-holes")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 1

    foil_hole = resp.json()["items"][0]
    assert foil_hole["resolution"] == 10
    assert foil_hole["particleCount"] == 35
    assert foil_hole["astigmatism"] == 1.35
