from unittest.mock import patch

import pytest

from ebic.utils import auth

pytestmark = pytest.mark.parametrize("client", ["aaa1111"], indirect=True)


@patch.object(auth, "get_user", return_value={"id": "aaa1111"}, autospec=True)
def test_get_all_proposals(mock_user, client):
    resp = client.get("/proposals")
    assert resp.status_code == 200
    assert resp.json()["total"] == 3


@patch.object(auth, "get_user", return_value={"id": "bbb2222"}, autospec=True)
def test_get_user_proposals(mock_user, client):
    resp = client.get("/proposals")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@patch.object(auth, "get_user", return_value={"id": "ccc3333"}, autospec=True)
def test_get_invalid_user_proposals(mock_user, client):
    resp = client.get("/proposals")
    assert resp.status_code == 403
