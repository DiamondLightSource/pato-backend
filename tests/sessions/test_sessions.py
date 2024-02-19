import pytest

from ..users import admin, em_admin, user


@pytest.mark.parametrize(
    ["mock_user", "expected_count"],
    [
        pytest.param(user, 1, id="user"),
        pytest.param(em_admin, 2, id="em"),
        pytest.param(admin, 2, id="admin"),
    ],
    indirect=["mock_user"],
)
def test_get(mock_user, expected_count, client):
    """Get all sessions"""
    resp = client.get("/sessions")
    assert resp.status_code == 200
    assert resp.json()["total"] == expected_count


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_get_admin(mock_user, client):
    """Get all visits (request from admin)"""
    resp = client.get("/sessions?proposal=cm31111")
    assert resp.status_code == 200
    assert resp.json()["total"] == 2


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_get_collection_groups(mock_user, client):
    """Get all visits with collection count"""
    resp = client.get("/sessions?countCollections=true")
    sessions = resp.json()

    assert resp.status_code == 200
    assert sessions["total"] == 2
    assert sessions["items"][0]["collectionGroups"] == 1


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_get_inexistent_proposal(mock_user, client):
    """Try to get visits for proposal that does not exist"""
    resp = client.get("/sessions?proposal=xx12345")
    assert resp.status_code == 404


@pytest.mark.parametrize("mock_user", [em_admin], indirect=True)
def test_get_em_admin(mock_user, client):
    """Get all visits belonging to EM (request from EM admin)"""
    resp = client.get("/sessions?proposal=cm31111")
    assert resp.status_code == 200
    assert resp.json()["total"] == 2


@pytest.mark.parametrize("mock_user", [user], indirect=True)
def test_get_user(mock_user, client):
    """Get all visits belonging to a regular user"""
    resp = client.get("/sessions?proposal=cm31111")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@pytest.mark.parametrize("mock_user", [user], indirect=True)
def test_get_forbidden(mock_user, client):
    """Try to get visits for proposal that does not belong to an user"""
    resp = client.get("/sessions?proposal=cm14451")
    assert resp.status_code == 404


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_date_end(mock_user, client):
    """Try to get visits between two dates"""
    resp = client.get(
        "/sessions?minEndDate=2022-10-21 09:00:00.000&maxEndDate=2024-10-21 09:00:00.000"  # noqa: E501
    )
    assert resp.status_code == 200
    assert resp.json()["total"] == 2


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_date_start(mock_user, client):
    """Try to get visits between two dates"""
    resp = client.get(
        "/sessions?minStartDate=2022-10-21 09:00:00.000&maxStartDate=2024-10-21 09:00:00.000"  # noqa: E501
    )
    assert resp.status_code == 200
    assert resp.json()["total"] == 2
