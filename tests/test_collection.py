import pytest

from .users import admin, em_admin, user


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_get_admin(mock_user, client):
    """Get all data collections in a visit (request for admin)"""
    resp = client.get("/dataCollections?groupId=5440740")
    assert resp.status_code == 200
    assert resp.json()["total"] == 2


@pytest.mark.parametrize("mock_user", [em_admin], indirect=True)
def test_get_em_admin(mock_user, client):
    """Get all collections in visit belonging to EM (request for EM admin)"""
    resp = client.get("/dataCollections?groupId=5440740")
    assert resp.status_code == 200
    assert resp.json()["total"] == 2


@pytest.mark.parametrize("mock_user", [em_admin], indirect=True)
def test_get_non_em(mock_user, client):
    """Try to get all collections belonging to a non-EM visit (request for EM admin)"""
    resp = client.get("/dataCollections?groupId=996311")
    assert resp.status_code == 404


@pytest.mark.parametrize("mock_user", [user], indirect=True)
def test_get_user(mock_user, client):
    """Get data collections in a visit belonging to a regular user"""
    resp = client.get("/dataCollections?groupId=5440743")
    assert resp.status_code == 200
    assert resp.json()["total"] == 2


@pytest.mark.parametrize("mock_user", [user], indirect=True)
def test_get_forbidden(mock_user, client):
    """Try to get data collections for a visit that does not belong to user"""
    resp = client.get("/dataCollections?groupId=5440740")
    assert resp.status_code == 404
