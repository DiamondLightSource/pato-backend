from unittest.mock import patch

import pytest

from ebic.utils import auth

pytestmark = pytest.mark.parametrize("client", ["aaa1111"], indirect=True)


@patch.object(auth, "get_user", return_value={"id": "admin"}, autospec=True)
def test_get_all_proposals(mock_user, client):
    """Get all proposals (request for admin)"""
    resp = client.get("/proposals")
    assert resp.status_code == 200
    assert resp.json()["total"] == 3


@patch.object(auth, "get_user", return_value={"id": "em_admin"}, autospec=True)
def test_get_all_em_proposals(mock_user, client):
    """Get all proposals belonging to EM (request for EM admin)"""
    resp = client.get("/proposals")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@patch.object(auth, "get_user", return_value={"id": "user"}, autospec=True)
def test_get_user_proposals(mock_user, client):
    """Get proposals belonging to a regular user"""
    resp = client.get("/proposals")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@patch.object(auth, "get_user", return_value={"id": "empty"}, autospec=True)
def test_get_no_proposals(mock_user, client):
    """Try to get proposals for user with no proposals"""
    resp = client.get("/proposals")
    assert resp.status_code == 404


@patch.object(auth, "get_user", return_value={"id": "nobody"}, autospec=True)
def test_get_invalid_user_proposals(mock_user, client):
    """Try to get proposals for invalid user"""
    resp = client.get("/proposals")
    assert resp.status_code == 403
