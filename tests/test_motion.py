import pytest

pytestmark = pytest.mark.parametrize("client", ["yrh59256"], indirect=True)


def test_motion(client):
    """Checks for valid motion response"""
    resp = client.get("/motion/1")
    assert resp.status_code == 200
    data = resp.json()
    assert data["total"] == 4
    assert data["rawTotal"] == 5


def test_no_motion(client):
    """Checks that response should be 404 for non existent motion"""
    resp = client.get("/motion/900")
    assert resp.status_code == 404
