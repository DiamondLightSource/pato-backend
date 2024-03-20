from unittest.mock import patch

import pytest

from ..conftest import mock_send


def include_type(original: str, is_3d: bool):
    divider_char = "&" if "?" in original else "?"
    return original + divider_char + (is_3d * "classType=3d")


@pytest.mark.parametrize(["is_3d", "row_count"], [[False, 5], [True, 3]])
def test_get_user(is_3d, row_count, mock_permissions, client):
    """Get classification data for an autoprocessing program"""
    resp = client.get(include_type("/autoProc/56986680/classification", is_3d))
    assert resp.status_code == 200
    assert resp.json()["total"] == row_count


@pytest.mark.parametrize(["is_3d", "value"], [[False, 9], [True, 10]])
def test_sort_resolution(is_3d, value, mock_permissions, client):
    """Get classification data for an autoprocessing program and sort by estimated
    resolution"""
    resp = client.get(
        include_type("/autoProc/56986680/classification?sortBy=resolution", is_3d)
    )
    assert resp.status_code == 200
    assert resp.json()["items"][0]["estimatedResolution"] == value
    assert resp.json()["items"][-1]["estimatedResolution"] == 0


@pytest.mark.parametrize("is_3d", [False, True])
def test_sort_particles(is_3d, mock_permissions, client):
    """Get particle picking data for an autoprocessing program and sort by particles
    per class"""
    resp = client.get(include_type("/autoProc/56986680/classification", is_3d))
    assert resp.status_code == 200
    assert resp.json()["items"][0]["particlesPerClass"] == 60000


@pytest.mark.parametrize("is_3d", [False, True])
def test_sort_class(is_3d, mock_permissions, client):
    """Get particle picking data for an autoprocessing program and sort by
    class distribution"""
    resp = client.get(
        include_type("/autoProc/56986680/classification?sortBy=class", is_3d)
    )
    assert resp.status_code == 200
    assert resp.json()["items"][0]["classDistribution"] == 0.3


@pytest.mark.parametrize("image_type", ["image", "angleDistribution"])
def test_get_image(image_type, mock_permissions, client):
    """Get class/angle distribution image"""
    with patch("pato.routes.movies.FileResponse.__call__", new=mock_send):
        resp = client.get(f"/autoProc/56986680/classification/1/{image_type}")
    assert resp.status_code == 200


@pytest.mark.parametrize("image_type", ["image", "angleDistribution"])
def test_get_image_not_in_db(image_type, mock_permissions, client):
    """Get class/angle distribution  image not in database"""
    with patch("pato.routes.movies.FileResponse.__call__", new=mock_send):
        resp = client.get(f"/autoProc/56986680/classification/999/{image_type}")
    assert resp.status_code == 404


@pytest.mark.parametrize("image_type", ["image", "angleDistribution"])
def test_get_image_not_found(image_type, mock_permissions, exists_mock, client):
    """Get class/angle distribution image not in filesystem"""
    exists_mock.return_value = False
    resp = client.get(f"/autoProc/56986680/classification/5/{image_type}")
    assert resp.status_code == 404


@pytest.mark.parametrize(["is_3d", "row_count"], [[False, 2], [True, 3]])
def test_filter_unselected(is_3d, row_count, mock_permissions, client):
    """Get only selected classes"""
    resp = client.get(
        include_type("/autoProc/56986680/classification?excludeUnselected=true", is_3d)
    )
    assert resp.json()["total"] == row_count
