import pytest

from pato.utils.config import Config

from ..users import admin, em_admin, industrial_user, user


@pytest.mark.parametrize(
    ["mock_user", "expected_count"],
    [
        pytest.param(user, 1, id="user"),
        pytest.param(industrial_user, 1, id="industrial-user"),
        pytest.param(em_admin, 3, id="em"),
        pytest.param(admin, 3, id="admin"),
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
    assert sessions["total"] == 3
    assert sessions["items"][0]["collectionGroups"] == 1


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_get_inexistent_proposal(mock_user, client):
    """Try to get visits for proposal that does not exist"""
    resp = client.get("/sessions?proposal=xx12345")
    sessions = resp.json()

    assert resp.status_code == 200
    assert sessions["total"] == 0


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
    sessions = resp.json()

    assert resp.status_code == 200
    assert sessions["total"] == 0


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_date_end(mock_user, client):
    """Try to get visits between two dates"""
    resp = client.get(
        "/sessions?minEndDate=2022-10-21 09:00:00.000&maxEndDate=2024-10-21 09:00:00.000"
    )
    assert resp.status_code == 200
    assert resp.json()["total"] == 2


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_date_start(mock_user, client):
    """Try to get visits between two dates"""
    resp = client.get(
        "/sessions?minStartDate=2022-10-21 09:00:00.000&maxStartDate=2024-10-21 09:00:00.000"
    )
    assert resp.status_code == 200
    assert resp.json()["total"] == 2

@pytest.mark.parametrize(
    ["mock_user", "expected_count"],
    [
        pytest.param(user, 0, id="user"),
        pytest.param(em_admin, 0, id="em"),
        pytest.param(industrial_user, 1, id="industrial-user"),
        pytest.param(admin, 1, id="admin"),
    ],
    indirect=["mock_user"],
)
def test_industrial_users_only(mock_user, expected_count, client):
    """Only return non-industrial sessions to non-admin staff if users_only_on_industrial is set """
    Config.facility.users_only_on_industrial = True
    resp = client.get(
        "/sessions?proposal=in1"
    )
    Config.facility.users_only_on_industrial = False

    assert resp.status_code == 200
    assert resp.json()["total"] == expected_count
