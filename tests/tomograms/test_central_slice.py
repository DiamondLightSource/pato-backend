from unittest.mock import patch

import pytest

from ..conftest import mock_send


def test_get(mock_permissions, client):
    """Get central slice for tomogram"""
    with patch("pato.routes.tomograms.FileResponse.__call__", new=mock_send):
        resp = client.get("/tomograms/1/centralSlice")
        assert resp.status_code == 200


@pytest.mark.parametrize("movie_type, expected", [("segmented", "denoised_segmented"), ("denoised", "denoised")])
def test_get_movie_type(mock_permissions, exists_mock, client, movie_type, expected):
    """Get central slice for tomogram by processing type"""
    with patch("pato.routes.tomograms.FileResponse.__call__", new=mock_send):
        resp = client.get(f"/tomograms/1/centralSlice?movieType={movie_type}")
        assert resp.status_code == 200
        exists_mock.assert_called_with(f"/dls/test.{expected}_thumbnail.png")


def test_get_denoised_invalid_name(mock_permissions, exists_mock, client):
    """Get denoised central slice for tomogram (with non-conforming filename)"""
    with patch("pato.routes.tomograms.FileResponse.__call__", new=mock_send):
        resp = client.get("/tomograms/2/centralSlice?movieType=denoised")
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

@pytest.mark.parametrize("movie_type, expected", [("segmented", "denoised_segmented"), ("denoised", "denoised")])
def test_get_movie_type_processed(mock_permissions, exists_mock, client, movie_type, expected):
    """Get central slice for tomogram by processing type from ProcessedTomogram table"""
    with patch("pato.routes.tomograms.FileResponse.__call__", new=mock_send):
        resp = client.get(f"/tomograms/3/centralSlice?movieType={movie_type}")
        assert resp.status_code == 200
        exists_mock.assert_called_with(f"/dls/test.{expected}_thumbnail.jpeg")
