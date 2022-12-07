import pytest


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_get_em_admin(mock_permissions, client):
    """Get central slice for tomogram"""
    resp = client.get("/tomograms/1/centralSlice")
    assert resp.status_code == 200


@pytest.mark.parametrize("mock_permissions", [403], indirect=True)
def test_get_forbidden(mock_permissions, client):
    """Get all central slice for tomogram not belonging to user"""
    resp = client.get("/tomograms/1/centralSlice")
    assert resp.status_code == 403


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_file_not_found(mock_permissions, exists_mock, client):
    """Try to get image file that does not exist"""
    exists_mock.return_value = False
    resp = client.get("/tomograms/1/centralSlice")
    assert resp.status_code == 404


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_inexistent_file(mock_permissions, client):
    """Try to get central slice for tomogram not in database"""
    resp = client.get("/tomograms/221/centralSlice")
    assert resp.status_code == 404
