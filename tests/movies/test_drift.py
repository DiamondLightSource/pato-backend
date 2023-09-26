from unittest.mock import mock_open, patch

import pytest


@pytest.fixture(scope="module", autouse=True)
def file_mock():
    with patch(
        "builtins.open",
        new_callable=mock_open,
        read_data='{"data": [{"y": [1,2,3,4]}]}',
    ) as _fixture:
        yield _fixture


def test_get(mock_permissions, client):
    """Get motion correction drift information"""
    resp = client.get("/movies/1/drift")
    assert resp.status_code == 200
    assert resp.json()["items"][0]["y"] == 1


def test_inexistent_file(mock_permissions, exists_mock, client):
    """Get motion correction drift information for inexistent file"""
    exists_mock.return_value = False
    resp = client.get("/movies/1/drift")
    assert resp.status_code == 404


def test_not_found(mock_permissions, client):
    """Get motion correction drift information for motion correction not in database"""
    resp = client.get("/movies/221/drift")
    assert resp.status_code == 404


def test_from_db(mock_permissions, client):
    """Get motion correction drift information based on
    MotionCorrectDrift table instead of file"""
    resp = client.get("/movies/1/drift?fromDb=true")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 3


def test_from_db_fall_back_to_file(mock_permissions, client):
    """Try to get motion correction drift information based on
    MotionCorrectDrift table and fall back to file"""
    resp = client.get("/movies/20/drift?fromDb=true")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 4


def test_from_db_inexistent_file(mock_permissions, exists_mock, client):
    """Get motion correction drift information from table, fall back
    to file, detect file does not exist"""
    exists_mock.return_value = False
    resp = client.get("/movies/20/drift?fromDb=true")
    assert resp.status_code == 404
