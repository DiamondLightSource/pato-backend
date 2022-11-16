from unittest.mock import patch

import pytest

from ebic.utils import auth

pytestmark = pytest.mark.parametrize("client", ["yrh59256"], indirect=True)


@patch.object(auth, "get_user", return_value={"id": "admin"}, autospec=True)
def test_get_admin(mock_user, client):
    """Get CTF data in a tomogram (request for admin)"""
    resp = client.get("/ctf/1")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 4


@patch.object(auth, "get_user", return_value={"id": "em_admin"}, autospec=True)
def test_get_em_admin(mock_user, client):
    """Get CTF data in a tomogram (request for EM admin).
    Non-EM tomograms cannot exist."""
    resp = client.get("/ctf/1")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 4


@patch.object(auth, "get_user", return_value={"id": "user"}, autospec=True)
def test_get_user(mock_user, client):
    """Get CTF data in a tomogram belonging to user"""
    resp = client.get("/ctf/2")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 4


@patch.object(auth, "get_user", return_value={"id": "user"}, autospec=True)
def test_get_forbidden(mock_user, client):
    """Try to get CTF data in a tomogram that does not belong to user"""
    resp = client.get("/ctf/1")
    assert resp.status_code == 403
