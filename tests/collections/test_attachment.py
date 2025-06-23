from unittest.mock import patch

from ..conftest import mock_send


def test_get(mock_permissions, client):
    """Get data collection attachment"""
    with patch("pato.routes.tomograms.FileResponse.__call__", new=mock_send):
        resp = client.get("/dataCollections/6017413/attachments/2")
    assert resp.status_code == 200


def test_file_not_found(mock_permissions, exists_mock, client):
    """Try to get attachment that does not exist in filesystem"""
    exists_mock.return_value = False
    resp = client.get("/dataCollections/6017413/attachments/2")
    assert resp.status_code == 404


def test_get_no_tomogram(mock_permissions, client):
    """Should raise error when attachment does not exist in table"""
    resp = client.get("/dataCollections/6017413/attachments/99999999")
    assert resp.status_code == 404
