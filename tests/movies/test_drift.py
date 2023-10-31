from unittest.mock import mock_open, patch

import pytest


@pytest.fixture(scope="module", autouse=True)
def file_mock():
    with patch(
        "builtins.open",
        new_callable=mock_open,
        read_data='{"data": [{"y": [1,2,3,4],"x": [9,8,4,5]}]}',
    ) as _fixture:
        yield _fixture


def test_get(mock_permissions, client):
    """Get motion correction drift information"""
    resp = client.get("/movies/1/drift")
    assert resp.status_code == 200
    assert resp.json()["items"][0]["y"] == 1
    assert resp.json()["items"][0]["x"] == 9


def test_inexistent_file(mock_permissions, exists_mock, client):
    """Get motion correction drift information for inexistent file"""
    exists_mock.return_value = False
    resp = client.get("/movies/1/drift")
    assert resp.status_code == 404


def test_not_found(mock_permissions, client):
    """Get motion correction drift information for motion correction not in database"""
    resp = client.get("/movies/221/drift")
    assert resp.status_code == 404
