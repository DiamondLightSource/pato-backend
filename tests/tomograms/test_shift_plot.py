from unittest.mock import mock_open, patch

import pytest


@pytest.fixture(scope="module", autouse=True)
def file_mock():
    with patch(
        "builtins.open",
        new_callable=mock_open,
        read_data='{"data": [{"y": [1,2,3], "x": [1,2,3]}]}',
    ) as _fixture:
        yield _fixture


def test_get(mock_permissions, file_mock, client):
    """Get shift plot for motion correction"""
    resp = client.get("/tomograms/1/shiftPlot")

    assert resp.status_code == 200


@patch("builtins.open", new_callable=mock_open, read_data="")
def test_invalid_file(mock_, mock_permissions, client):
    """Try to get shift plot file that is not in a correct format"""
    resp = client.get("/tomograms/2/shiftPlot")
    assert resp.status_code == 500


@patch("builtins.open", new_callable=mock_open)
def test_file_not_found(mock_file, mock_permissions, client):
    """Try to get shift plot file that does not exist"""
    mock_file.side_effect = FileNotFoundError
    resp = client.get("/tomograms/2/shiftPlot")
    assert resp.status_code == 404


def test_inexistent_db(mock_permissions, client):
    """Try to get shift plot file not in database"""
    resp = client.get("/tomograms/999/shiftPlot")
    assert resp.status_code == 404
