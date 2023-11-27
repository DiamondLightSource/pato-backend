import pytest

from ..users import admin, em_admin, user


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_get_admin(mock_user, client):
    """Get all data collections in a visit (request for admin)"""
    resp = client.get("/dataGroups/5440740/dataCollections")
    assert resp.status_code == 200
    assert resp.json()["total"] == 3


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_get_index(mock_user, client):
    """Get data collections matching search and maintain index"""
    resp = client.get("/dataGroups/5440740/dataCollections?search=Processed")
    assert resp.status_code == 200
    assert resp.json()["items"][0]["index"] == 2


@pytest.mark.parametrize("mock_user", [em_admin], indirect=True)
def test_get_em_admin(mock_user, client):
    """Get all collections in visit belonging to EM (request for EM admin)"""
    resp = client.get("/dataGroups/5440740/dataCollections")
    assert resp.status_code == 200
    assert resp.json()["total"] == 3


@pytest.mark.parametrize("mock_user", [em_admin], indirect=True)
def test_get_non_em(mock_user, client):
    """Try to get all collections belonging to a non-EM visit (request for EM admin)"""
    resp = client.get("/dataGroups/996311/dataCollections")
    assert resp.status_code == 404


@pytest.mark.parametrize("mock_user", [user], indirect=True)
def test_get_user(mock_user, client):
    """Get data collections in a visit belonging to a regular user"""
    resp = client.get("/dataGroups/5440743/dataCollections")
    assert resp.status_code == 200
    assert resp.json()["total"] == 2


@pytest.mark.parametrize("mock_user", [user], indirect=True)
def test_get_forbidden(mock_user, client):
    """Try to get data collections for a visit that does not belong to user"""
    resp = client.get("/dataGroups/5440740/dataCollections")
    assert resp.status_code == 404


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_get_phase_plate_unused(mock_user, client):
    """Get phase plate status when column is set to not used"""
    resp = client.get("/dataGroups/5440740/dataCollections")
    assert resp.status_code == 200
    assert resp.json()["items"][0]["phasePlate"] == "No"


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_get_phase_plate_used(mock_user, client):
    """Get phase plate status when column is set to used"""
    resp = client.get("/dataGroups/5440740/dataCollections")
    assert resp.status_code == 200
    assert resp.json()["items"][1]["phasePlate"] == "Yes"


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_get_phase_plate_null(mock_user, client):
    """Get phase plate status when column is set to null"""
    resp = client.get("/dataGroups/5440740/dataCollections")
    assert resp.status_code == 200
    assert resp.json()["items"][2]["phasePlate"] == "No"


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_get_pixel_size(mock_user, client):
    """Get pixel size in ångstroms, when the value in the table is stored in nanometres"""
    resp = client.get("/dataGroups/5440740/dataCollections")
    assert resp.status_code == 200
    assert resp.json()["items"][1]["pixelSizeOnImage"] == 100


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_get_pixel_size_null(mock_user, client):
    """Get pixel size when the value in the table is null"""
    resp = client.get("/dataGroups/988855/dataCollections")
    assert resp.status_code == 200
    assert resp.json()["items"][0]["pixelSizeOnImage"] is None
