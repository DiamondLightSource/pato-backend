from unittest.mock import patch

import pytest

from ..conftest import mock_send


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_get_user(mock_permissions, client):
    """Get particle picking data for an autoprocessing program"""
    resp = client.get("/autoProc/56986680/classification")
    print(resp.json())
    assert resp.status_code == 200
    assert resp.json()["total"] == 5


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_sort_particles(mock_permissions, client):
    """Get particle picking data for an autoprocessing program and sort by particles
    per class"""
    resp = client.get("/autoProc/56986680/classification")
    print(resp.json())
    assert resp.status_code == 200
    assert resp.json()["items"][0]["particlesPerClass"] == 60000


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_sort_class(mock_permissions, client):
    """Get particle picking data for an autoprocessing program and sort by
    class distribution"""
    resp = client.get("/autoProc/56986680/classification?sortBy=class")
    print(resp.json())
    assert resp.status_code == 200
    assert resp.json()["items"][0]["classDistribution"] == 0.3


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_sort_resolution(mock_permissions, client):
    """Get particle picking data for an autoprocessing program and sort by estimated
    resolution"""
    resp = client.get("/autoProc/56986680/classification?sortBy=resolution")
    print(resp.json())
    assert resp.status_code == 200
    assert resp.json()["items"][0]["estimatedResolution"] == 18


@pytest.mark.parametrize("mock_permissions", [403], indirect=True)
def test_get_forbidden(mock_permissions, client):
    """Try to get particle picking data for an autoprocessing program where the user is
    not present in the parent session"""
    resp = client.get("/autoProc/56986680/classification")
    assert resp.status_code == 403


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_get_image(mock_permissions, client):
    """Get particle picking summary image"""
    with patch("ebic.routes.movies.FileResponse.__call__", new=mock_send):
        resp = client.get("/autoProc/56986680/classification/1/image")
    assert resp.status_code == 200


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_get_image_not_in_db(mock_permissions, client):
    """Get particle picking summary image not in database"""
    with patch("ebic.routes.movies.FileResponse.__call__", new=mock_send):
        resp = client.get("/autoProc/56986680/classification/999/image")
    assert resp.status_code == 404


@pytest.mark.parametrize("mock_permissions", [200], indirect=True)
def test_get_image_not_found(mock_permissions, exists_mock, client):
    """Get particle picking summary image not in filesystem"""
    exists_mock.return_value = False
    resp = client.get("/autoProc/56986680/classification/5/image")
    assert resp.status_code == 404


@pytest.mark.parametrize("mock_permissions", [403], indirect=True)
def test_get_image_forbidden(mock_permissions, client):
    """Try to get particle picking summary image for user not present
    in the parent session"""
    with patch("ebic.routes.movies.FileResponse.__call__", new=mock_send):
        resp = client.get("/autoProc/56986680/classification/1/image")
    assert resp.status_code == 403
