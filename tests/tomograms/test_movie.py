from unittest.mock import patch

import pytest

from tests.conftest import mock_send


def test_get_movie(mock_permissions, client):
    """Get movie image"""
    with patch("pato.routes.tomograms.FileResponse.__call__", new=mock_send):
        resp = client.get("/tomograms/1/movie")
    assert resp.status_code == 200

@pytest.mark.parametrize("movie_type, expected", [("segmented", "denoised_segmented"), ("denoised", "denoised")])
def test_get_movie_processing_type(mock_permissions, exists_mock, client, movie_type, expected):
    """Get movie by processing type"""
    with patch("pato.routes.tomograms.FileResponse.__call__", new=mock_send):
        resp = client.get(f"/tomograms/1/movie?movieType={movie_type}")
        exists_mock.assert_called_with(f"/dls/test.{expected}_movie.png")
    assert resp.status_code == 200

def test_get_denoised_invalid_name(mock_permissions, exists_mock, client):
    """Get denoised movie (with non-conforming filename)"""
    with patch("pato.routes.tomograms.FileResponse.__call__", new=mock_send):
        resp = client.get("/tomograms/2/movie?movieType=denoised")
        assert resp.status_code == 500


def test_file_not_found(mock_permissions, exists_mock, client):
    """Try to get movie image that does not exist"""
    exists_mock.return_value = False
    resp = client.get("/tomograms/1/movie")
    assert resp.status_code == 404


def test_inexistent_db(mock_permissions, client):
    """Try to get movie image that does not exist in database"""
    resp = client.get("/tomograms/999/movie")
    assert resp.status_code == 404

@pytest.mark.parametrize("movie_type, expected", [("segmented", "denoised_segmented"), ("denoised", "denoised")])
def test_get_movie_type_processed(mock_permissions, exists_mock, client, movie_type, expected):
    """Get denoised movie from ProcessedTomogram table"""
    with patch("pato.routes.tomograms.FileResponse.__call__", new=mock_send):
        resp = client.get(f"/tomograms/3/movie?movieType={movie_type}")
        exists_mock.assert_called_with(f"/dls/test.{expected}_movie.png")
    assert resp.status_code == 200
