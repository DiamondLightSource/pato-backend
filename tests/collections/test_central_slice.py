from unittest.mock import patch

import pytest

from ..conftest import mock_send

# This route uses the crud function at tomograms.get_slice_path, so duplicate tests are omitted

def test_get(mock_permissions, client):
    """Get central slice for data collection with a tomogram"""
    with patch("pato.routes.tomograms.FileResponse.__call__", new=mock_send):
        resp = client.get("/dataCollections/6017406/centralSlice")
    assert resp.status_code == 200

@pytest.mark.parametrize(
    "movie_type, expected",
    [("segmented", "denoised_segmented"), ("denoised", "denoised")],
)
def test_get_movie_type(mock_permissions, exists_mock, client, movie_type, expected):
    """Get central slice for tomogram by processing type"""
    with patch("pato.routes.tomograms.FileResponse.__call__", new=mock_send):
        resp = client.get(f"/dataCollections/6017406/centralSlice?movieType={movie_type}")
        assert resp.status_code == 200
        exists_mock.assert_called_with(f"/dls/test.{expected}_thumbnail.png")

def test_get_no_tomogram(mock_permissions, client):
    """Should raise error when getting central slice of data collection with no associated tomogram"""
    resp = client.get("/dataCollections/1052494/centralSlice")
    assert resp.status_code == 404
