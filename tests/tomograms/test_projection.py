from unittest.mock import patch

import pytest

from tests.conftest import mock_send


@pytest.mark.parametrize("proj_type", ["xy", "xz"])
def test_get(proj_type, mock_permissions, client):
    """Get projection on XY axis"""
    with patch("pato.routes.tomograms.FileResponse.__call__", new=mock_send):
        resp = client.get(f"/tomograms/1/projection?axis={proj_type}")
    assert resp.status_code == 200


@pytest.mark.parametrize("proj_type", ["xy", "xz"])
def test_file_not_found(proj_type, mock_permissions, exists_mock, client):
    """Try to get projection image that does not exist"""
    exists_mock.return_value = False
    resp = client.get(f"/tomograms/1/projection?axis={proj_type}")
    assert resp.status_code == 404


@pytest.mark.parametrize("proj_type", ["xy", "xz"])
def test_inexistent_db(proj_type, mock_permissions, client):
    """Try to get projection image file not in database"""
    resp = client.get(f"/tomograms/999/projection?axis={proj_type}")
    assert resp.status_code == 404
