from unittest.mock import patch

from ..conftest import mock_send


def test_get(mock_permissions, client):
    """Get central slice for tomogram"""
    with patch("pato.routes.tomograms.FileResponse.__call__", new=mock_send):
        resp = client.get("/tomograms/1/centralSlice")
        assert resp.status_code == 200


def test_get_denoised(mock_permissions, exists_mock, client):
    """Get denoised central slice for tomogram"""
    with patch("pato.routes.tomograms.FileResponse.__call__", new=mock_send):
        resp = client.get("/tomograms/1/centralSlice?denoised=true")
        assert resp.status_code == 200
        exists_mock.assert_called_with("/dls/test.denoised_thumbnail.png")


def test_get_denoised_invalid_name(mock_permissions, exists_mock, client):
    """Get denoised central slice for tomogram (with non-conforming filename)"""
    with patch("pato.routes.tomograms.FileResponse.__call__", new=mock_send):
        resp = client.get("/tomograms/2/centralSlice?denoised=true")
        assert resp.status_code == 500


def test_file_not_found(mock_permissions, exists_mock, client):
    """Try to get image file that does not exist"""
    exists_mock.return_value = False
    resp = client.get("/tomograms/1/centralSlice")
    assert resp.status_code == 404


def test_inexistent_file(mock_permissions, client):
    """Try to get central slice for tomogram not in database"""
    resp = client.get("/tomograms/221/centralSlice")
    assert resp.status_code == 404
