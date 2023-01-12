from unittest.mock import patch

from ..conftest import mock_send


def test_get_user(mock_permissions, client):
    """Get particle picking data for an autoprocessing program"""
    resp = client.get("/autoProc/56986680/particlePicker")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 6


def test_get_user_not_null(mock_permissions, client):
    """Get particle picking data for an autoprocessing program (filter null
    particle picking rows)"""
    resp = client.get("/autoProc/56986680/particlePicker?filterNull=true")
    assert resp.status_code == 200
    assert len(resp.json()["items"]) == 2


def test_get_image(mock_permissions, client):
    """Get particle picking summary image"""
    with patch("ebic.routes.autoproc.FileResponse.__call__", new=mock_send):
        resp = client.get("/autoProc/56986680/particlePicker/1/image")
    assert resp.status_code == 200


def test_get_image_not_in_db(mock_permissions, client):
    """Get particle picking summary image not in database"""
    with patch("ebic.routes.autoproc.FileResponse.__call__", new=mock_send):
        resp = client.get("/autoProc/56986680/particlePicker/5/image")
    assert resp.status_code == 404


def test_get_image_not_found(mock_permissions, exists_mock, client):
    """Get particle picking summary image not in filesystem"""
    exists_mock.return_value = False
    resp = client.get("/autoProc/56986680/particlePicker/5/image")
    assert resp.status_code == 404
