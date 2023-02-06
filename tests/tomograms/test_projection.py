from unittest.mock import patch

from tests.conftest import mock_send


def test_get_xy(mock_permissions, client):
    """Get projection on XY axis"""
    with patch("pato.routes.tomograms.FileResponse.__call__", new=mock_send):
        resp = client.get("/tomograms/1/projection?axis=xy")
    assert resp.status_code == 200


def test_get_xz(mock_permissions, client):
    """Get projection on XZ axis"""
    with patch("pato.routes.tomograms.FileResponse.__call__", new=mock_send):
        resp = client.get("/tomograms/1/projection?axis=xz")
    assert resp.status_code == 200


def test_file_not_found(mock_permissions, exists_mock, client):
    """Try to get projection image that does not exist"""
    exists_mock.return_value = False
    resp = client.get("/tomograms/1/projection?axis=xz")
    assert resp.status_code == 404


def test_inexistent_db(mock_permissions, client):
    """Try to get projection image file not in database"""
    resp = client.get("/tomograms/999/projection?axis=xy")
    assert resp.status_code == 404
