from unittest.mock import mock_open, patch

import pytest
from ebic.utils.auth import AuthUser


@pytest.fixture(scope="module", autouse=True)
def file_mock():
    with patch(
        "builtins.open", new_callable=mock_open, read_data='{"data": [{"y": [1,2,3]}]}'
    ) as _fixture:
        yield _fixture


@patch.object(AuthUser, "auth", return_value="admin", autospec=True)
def test_get_admin(mock_user, file_mock, client):
    """Get shift plot for motion correction (request for admin)"""
    resp = client.get("/shiftPlot/1")

    assert resp.status_code == 200


@patch.object(AuthUser, "auth", return_value="em_admin", autospec=True)
def test_get_em_admin(mock_user, client):
    """Get shift plot for motion correction (request for EM admin).
    Non-EM tomograms cannot exist."""
    resp = client.get("/shiftPlot/1")
    assert resp.status_code == 200


@patch.object(AuthUser, "auth", return_value="user", autospec=True)
def test_get_user(mock_user, client):
    """Get all shift plot for motion correction belonging to user"""
    resp = client.get("/shiftPlot/2")
    assert resp.status_code == 200


@patch.object(AuthUser, "auth", return_value="user", autospec=True)
def test_get_forbidden(mock_user, client):
    """Get all shift plot for motion correction not belonging to user"""
    resp = client.get("/shiftPlot/1")
    assert resp.status_code == 403


@patch("builtins.open", new_callable=mock_open, read_data="")
@patch.object(AuthUser, "auth", return_value="user", autospec=True)
def test_invalid_file(mock_user, mock_file, client):
    """Try to get shift plot file that is not in a correct format"""
    resp = client.get("/shiftPlot/2")
    assert resp.status_code == 500


@patch("builtins.open", new_callable=mock_open)
@patch.object(AuthUser, "auth", return_value="user", autospec=True)
def test_file_not_found(mock_user, mock_file, client):
    """Try to get shift plot file that does not exist"""
    mock_file.side_effect = FileNotFoundError
    resp = client.get("/shiftPlot/2")
    assert resp.status_code == 404


@patch.object(AuthUser, "auth", return_value="user", autospec=True)
def test_inexistent_file(mock_user, client):
    """Try to get shift plot file not in database"""
    resp = client.get("/shiftPlot/999")
    assert resp.status_code == 404
