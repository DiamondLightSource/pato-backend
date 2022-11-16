from unittest.mock import patch

from ebic.utils import auth


@patch.object(auth, "get_user", return_value={"id": "admin"}, autospec=True)
def test_get_admin(mock_user, client):
    """Get all data collections in a visit (request for admin)"""
    resp = client.get("/collections?visit=27464088")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@patch.object(auth, "get_user", return_value={"id": "em_admin"}, autospec=True)
def test_get_em_admin(mock_user, client):
    """Get all collections in visit belonging to EM (request for EM admin)"""
    resp = client.get("/collections?visit=27464088")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@patch.object(auth, "get_user", return_value={"id": "em_admin"}, autospec=True)
def test_get_non_em(mock_user, client):
    """Try to get all collections belonging to a non-EM visit (request for EM admin)"""
    resp = client.get("/collections?visit=55167")
    assert resp.status_code == 404


@patch.object(auth, "get_user", return_value={"id": "user"}, autospec=True)
def test_get_user(mock_user, client):
    """Get data collections in a visit belonging to a regular user"""
    resp = client.get("/collections?visit=27464089")
    assert resp.status_code == 200
    assert resp.json()["total"] == 2


@patch.object(auth, "get_user", return_value={"id": "user"}, autospec=True)
def test_get_forbidden(mock_user, client):
    """Try to get data collections for a visit that does not belong to user"""
    resp = client.get("/collections?visit=27464088")
    assert resp.status_code == 404
