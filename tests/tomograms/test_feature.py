from unittest.mock import patch

from tests.conftest import mock_send


def test_get(mock_permissions, client):
    """Get tomogram feature"""
    with patch("pato.routes.tomograms.FileResponse.__call__", new=mock_send):
        resp = client.get("/tomograms/3/features/membrane")
    assert resp.status_code == 200


def test_file_not_found(mock_permissions, exists_mock, client):
    """Try to get feature that does not exist on disk"""
    exists_mock.return_value = False
    resp = client.get("/tomograms/3/features/membrane")
    assert resp.status_code == 404


def test_inexistent_db(mock_permissions, client):
    """Try to get feature not in database"""
    resp = client.get("/tomograms/3/features/ribosome")
    assert resp.status_code == 404
