from unittest.mock import mock_open, patch

import pytest

from .users import admin, em_admin, user


@pytest.fixture(scope="module", autouse=True)
def file_mock():
    with patch(
        "builtins.open", new_callable=mock_open, read_data='{"data": [{"y": [1,2,3]}]}'
    ) as _fixture:
        yield _fixture


@pytest.mark.parametrize("override_user", [admin], indirect=True)
def test_get_admin(override_user, file_mock, client):
    """Get shift plot for motion correction (request for admin)"""
    resp = client.get("/tomograms/1/shiftPlot")

    assert resp.status_code == 200


@pytest.mark.parametrize("override_user", [em_admin], indirect=True)
def test_get_em_admin(override_user, client):
    """Get shift plot for motion correction (request for EM admin).
    Non-EM tomograms cannot exist."""
    resp = client.get("/tomograms/1/shiftPlot")
    assert resp.status_code == 200


@pytest.mark.parametrize("override_user", [user], indirect=True)
def test_get_user(override_user, client):
    """Get all shift plot for motion correction belonging to user"""
    resp = client.get("/tomograms/2/shiftPlot")
    assert resp.status_code == 200


@pytest.mark.parametrize("override_user", [user], indirect=True)
def test_get_forbidden(override_user, client):
    """Get all shift plot for motion correction not belonging to user"""
    resp = client.get("/tomograms/1/shiftPlot")
    assert resp.status_code == 403


@pytest.mark.parametrize("override_user", [user], indirect=True)
@patch("builtins.open", new_callable=mock_open, read_data="")
def test_invalid_file(mock_file, override_user, client):
    """Try to get shift plot file that is not in a correct format"""
    resp = client.get("/tomograms/2/shiftPlot")
    assert resp.status_code == 500


@patch("builtins.open", new_callable=mock_open)
@pytest.mark.parametrize("override_user", [user], indirect=True)
def test_file_not_found(mock_file, override_user, client):
    """Try to get shift plot file that does not exist"""
    mock_file.side_effect = FileNotFoundError
    resp = client.get("/tomograms/2/shiftPlot")
    assert resp.status_code == 404


@pytest.mark.parametrize("override_user", [user], indirect=True)
def test_inexistent_file(override_user, client):
    """Try to get shift plot file not in database"""
    resp = client.get("/tomograms/999/shiftPlot")
    assert resp.status_code == 404
