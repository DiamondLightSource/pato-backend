from unittest.mock import patch

from ..conftest import mock_send


def test_get_user(mock_permissions, client):
    """Get particle picking data for an autoprocessing program"""
    resp = client.get("/autoProc/56986680/classification")
    assert resp.status_code == 200
    assert resp.json()["total"] == 5


def test_sort_particles(mock_permissions, client):
    """Get particle picking data for an autoprocessing program and sort by particles
    per class"""
    resp = client.get("/autoProc/56986680/classification")
    assert resp.status_code == 200
    assert resp.json()["items"][0]["particlesPerClass"] == 60000


def test_sort_class(mock_permissions, client):
    """Get particle picking data for an autoprocessing program and sort by
    class distribution"""
    resp = client.get("/autoProc/56986680/classification?sortBy=class")
    assert resp.status_code == 200
    assert resp.json()["items"][0]["classDistribution"] == 0.3


def test_sort_resolution(mock_permissions, client):
    """Get particle picking data for an autoprocessing program and sort by estimated
    resolution"""
    resp = client.get("/autoProc/56986680/classification?sortBy=resolution")
    assert resp.status_code == 200
    assert resp.json()["items"][0]["estimatedResolution"] == 18


def test_get_image(mock_permissions, client):
    """Get particle picking summary image"""
    with patch("pato.routes.movies.FileResponse.__call__", new=mock_send):
        resp = client.get("/autoProc/56986680/classification/1/image")
    assert resp.status_code == 200


def test_get_image_not_in_db(mock_permissions, client):
    """Get particle picking summary image not in database"""
    with patch("pato.routes.movies.FileResponse.__call__", new=mock_send):
        resp = client.get("/autoProc/56986680/classification/999/image")
    assert resp.status_code == 404


def test_get_image_not_found(mock_permissions, exists_mock, client):
    """Get particle picking summary image not in filesystem"""
    exists_mock.return_value = False
    resp = client.get("/autoProc/56986680/classification/5/image")
    assert resp.status_code == 404
