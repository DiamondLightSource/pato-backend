import pytest


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_get_admin(mock_permissions, client):
    """Get micrograph for motion correction (request for admin)"""
    resp = client.get("/image/micrograph/1")
    assert resp.status_code == 200


@pytest.mark.parametrize("mock_permissions", [403], indirect=True)
def test_get_forbidden(mock_permissions, client):
    """Get all micrograph for motion correction not belonging to user"""
    resp = client.get("/image/micrograph/1")
    assert resp.status_code == 403


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_file_not_found(mock_permissions, exists_mock, client):
    """Try to get image file that does not exist"""
    exists_mock.return_value = False
    resp = client.get("/image/micrograph/1")
    assert resp.status_code == 404


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_inexistent_file(mock_permissions, client):
    """Try to get micrograph for motion correction not in database"""
    resp = client.get("/image/micrograph/221")
    assert resp.status_code == 404
