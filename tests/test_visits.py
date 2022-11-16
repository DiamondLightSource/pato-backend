from unittest.mock import patch

import pytest

from ebic.utils import auth

pytestmark = pytest.mark.parametrize("client", ["aaa1111"], indirect=True)


@patch.object(auth, "get_user", return_value={"id": "admin"}, autospec=True)
def test_get_all_visits(mock_user, client):
    """Get all visits (request from admin)"""
    resp = client.get("/visits?prop=cm14451")
    assert resp.status_code == 200
    assert resp.json()["total"] == 3


@patch.object(auth, "get_user", return_value={"id": "admin"}, autospec=True)
def test_get_visits_of_inexistent_proposal(mock_user, client):
    """Try to get visits for proposal that does not exist"""
    resp = client.get("/visits?prop=xx12345")
    assert resp.status_code == 404


@patch.object(auth, "get_user", return_value={"id": "em_admin"}, autospec=True)
def test_get_all_em_visits(mock_user, client):
    """Get all visits belonging to EM (request from EM admin)"""
    resp = client.get("/visits?prop=cm31111")
    assert resp.status_code == 200
    assert resp.json()["total"] == 2


@patch.object(auth, "get_user", return_value={"id": "user"}, autospec=True)
def test_get_user_visits(mock_user, client):
    """Get all visits belonging to a regular user"""
    resp = client.get("/visits?prop=cm31111")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@patch.object(auth, "get_user", return_value={"id": "user"}, autospec=True)
def test_get_forbidden_user_visits(mock_user, client):
    """Try to get visits for proposal that does not belong to an user"""
    resp = client.get("/visits?prop=cm14451")
    assert resp.status_code == 404
