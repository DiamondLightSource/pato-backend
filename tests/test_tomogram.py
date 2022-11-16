from unittest.mock import patch

import pytest

from ebic.utils import auth

pytestmark = pytest.mark.parametrize("client", ["yrh59256"], indirect=True)


@patch.object(auth, "get_user", return_value={"id": "admin"}, autospec=True)
def test_get_all_tomograms(mock_user, client):
    """Get all tomograms in a data collection (request for admin)"""
    resp = client.get("/tomograms/6017406")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@patch.object(auth, "get_user", return_value={"id": "user"}, autospec=True)
def test_get_user_tomograms(mock_user, client):
    """Get all tomograms in a data collection belonging to user"""
    resp = client.get("/tomograms/6017408")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@patch.object(auth, "get_user", return_value={"id": "user"}, autospec=True)
def test_get_forbidden_tomograms(mock_user, client):
    """Try to get tomograms in a data collection that does not belong to user"""
    resp = client.get("/tomograms/6017406")
    assert resp.status_code == 403
