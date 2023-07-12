import pytest

from ..users import admin, em_admin, mx_admin, user


@pytest.mark.parametrize(
    ["mock_user", "expected_count"],
    [
        pytest.param(mx_admin, 2, id="mx"),
        pytest.param(user, 1, id="user"),
        pytest.param(em_admin, 1, id="em"),
        pytest.param(admin, 4, id="admin"),
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
