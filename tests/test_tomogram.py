import pytest


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_get_user(mock_permissions, client):
    """Get tomogram in a data collection belonging to user"""
    resp = client.get("/dataCollections/6017408/tomogram")
    assert resp.status_code == 200


@pytest.mark.parametrize("mock_permissions", [403], indirect=True)
def test_get_forbidden(mock_permissions, client):
    """Try to get tomogram in a data collection that does not belong to user"""
    resp = client.get("/dataCollections/6017406/tomogram")
    assert resp.status_code == 403
