from unittest.mock import patch

from tests.conftest import mock_send


def test_get_movie(mock_permissions, client):
    """Get movie image"""
    with patch("pato.routes.tomograms.FileResponse.__call__", new=mock_send):
        resp = client.get("/tomograms/1/movie")
    assert resp.status_code == 200


def test_get_denoised(mock_permissions, exists_mock, client):
    """Get denoised movie"""
    with patch("pato.routes.tomograms.FileResponse.__call__", new=mock_send):
        resp = client.get("/tomograms/1/movie?movieType=denoised")
        exists_mock.assert_called_with("/dls/test.denoised_movie.png")
    assert resp.status_code == 200


def test_get_segmented(mock_permissions, exists_mock, client):
    """Get segmented movie"""
    with patch("pato.routes.tomograms.FileResponse.__call__", new=mock_send):
        resp = client.get("/tomograms/1/movie?movieType=segmented")
        exists_mock.assert_called_with("/dls/test.denoised_segmented_movie.png")
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
