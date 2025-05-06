import pytest


def test_get(mock_permissions, client):
    """Get foil holes belonging to grid square"""
    resp = client.get("/grid-squares/1/foil-holes")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 1
    assert resp.json()["items"][0]["movieCount"] == 2


@pytest.mark.parametrize(
    ["target", "value"],
    [
        pytest.param("resolution", 10, id="resolution"),
        pytest.param("particleCount", 35, id="particle_count"),
        pytest.param("astigmatism", 13.5, id="astigmatism"),
        pytest.param("defocus", 13, id="defocus"),
    ],
)
def test_get_metrics(mock_permissions, target, value, client):
    """Get average CTF values for foil holes"""
    resp = client.get(f"/grid-squares/1/foil-holes?targetMetric={target}")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 1
    assert resp.json()["items"][0]["val"] == value
