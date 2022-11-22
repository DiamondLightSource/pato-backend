from unittest.mock import patch
from ebic.utils.auth import AuthUser


@patch.object(AuthUser, "auth", return_value="admin", autospec=True)
def test_get_admin(mock_user, client):
    """Get central slice for tomogram (request for admin)"""
    resp = client.get("/image/slice/1")
    assert resp.status_code == 200


@patch.object(AuthUser, "auth", return_value="em_admin", autospec=True)
def test_get_em_admin(mock_user, client):
    """Get central slice for tomogram (request for EM admin)."""
    resp = client.get("/image/slice/1")
    assert resp.status_code == 200


@patch.object(AuthUser, "auth", return_value="user", autospec=True)
def test_get_user(mock_user, client):
    """Get all central slice for tomogram belonging to user"""
    resp = client.get("/image/slice/2")
    assert resp.status_code == 200


@patch.object(AuthUser, "auth", return_value="user", autospec=True)
def test_get_forbidden(mock_user, client):
    """Get all central slice for tomogram not belonging to user"""
    resp = client.get("/image/slice/1")
    assert resp.status_code == 403


@patch.object(AuthUser, "auth", return_value="admin", autospec=True)
def test_file_not_found(mock_user, exists_mock, client):
    """Try to get image file that does not exist"""
    exists_mock.return_value = False
    resp = client.get("/image/slice/1")
    assert resp.status_code == 404


@patch.object(AuthUser, "auth", return_value="admin", autospec=True)
def test_inexistent_file(mock_user, client):
    """Try to get central slice for tomogram not in database"""
    resp = client.get("/image/slice/221")
    assert resp.status_code == 404
