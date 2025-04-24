import pytest

from pato.utils.config import Config

from ..users import admin, em_admin, industrial_user, mx_admin, user


@pytest.mark.parametrize(
    ["mock_user", "expected_count"],
    [
        pytest.param(mx_admin, 2, id="mx"),
        pytest.param(industrial_user, 1, id="industrial_user"),
        pytest.param(user, 1, id="user"),
        pytest.param(em_admin, 2, id="em"),
        pytest.param(admin, 6, id="admin"),
    ],
    indirect=["mock_user"],
)
def test_get(mock_user, expected_count, client):
    """Get all proposals"""
    resp = client.get("/proposals")
    assert resp.status_code == 200
    assert resp.json()["total"] == expected_count


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_search_code(mock_user, client):
    """Get all proposals with a matching proposal code"""
    resp = client.get("/proposals?search=bi")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_search_number(mock_user, client):
    """Get all proposals with a matching proposal number"""
    resp = client.get("/proposals?search=8")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_search_full(mock_user, client):
    """Get all proposals with a matching proposal code and number"""
    resp = client.get("/proposals?search=cm31")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_search_title(mock_user, client):
    """Get all proposals with a matching title"""
    resp = client.get("/proposals?search=Test%20Proposal")
    assert resp.status_code == 200
    assert resp.json()["total"] == 2


@pytest.mark.parametrize(
    ["mock_user", "expected_count"],
    [
        pytest.param(mx_admin, 2, id="mx"),
        pytest.param(industrial_user, 1, id="industrial_user"),
        pytest.param(user, 1, id="user"),
        pytest.param(em_admin, 1, id="em"),
        pytest.param(admin, 5, id="admin"),
    ],
    indirect=["mock_user"],
)
def test_industrial_users_only(mock_user, expected_count, client):
    """Only return non-industrial proposals to staff if users_only_on_industrial is set"""
    Config.facility.users_only_on_industrial = True
    resp = client.get("/proposals")
    Config.facility.users_only_on_industrial = False

    assert resp.status_code == 200
    assert resp.json()["total"] == expected_count
