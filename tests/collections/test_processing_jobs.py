import pytest


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_get_admin(mock_permissions, client):
    """Get all processing jobs for a given collection"""
    resp = client.get("/dataCollections/6017408/processingJobs")
    assert resp.status_code == 200
    assert resp.json()["total"] == 1


@pytest.mark.parametrize("mock_permissions", [403], indirect=True)
def test_get_em_admin(mock_permissions, client):
    """Try to get processing jobs for session in which user is not present"""
    resp = client.get("/dataCollections/6017412/processingJobs")
    assert resp.status_code == 403
