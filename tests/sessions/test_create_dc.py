from datetime import datetime
from unittest.mock import patch

import pytest
from lims_utils.tables import BLSession

from ..users import admin


def active_mock(_):
    return BLSession(
        startDate=datetime(year=2022, month=1, day=1),
        sessionId=27464088,
        beamLineName="m12",
    )


def raw_check_mock(_, _1):
    return


full_params = {"fileDirectory": "raw", "fileExtension": ".tif"}


@patch("pato.crud.sessions._check_raw_files_exist", new=raw_check_mock)
@patch("pato.crud.sessions._validate_session_active", new=active_mock)
@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_post(mock_user, mock_permissions, client):
    """Create new data collection in session"""
    resp = client.post(
        "/proposals/cm31111/sessions/5/dataCollections",
        json={**full_params, "fileDirectory": "raw2"},
    )
    assert resp.status_code == 201

    data = resp.json()

    assert data["imageDirectory"] == "/dls/m12/data/2022/cm31111-5/raw2/"


@patch("pato.crud.sessions._check_raw_files_exist", new=raw_check_mock)
@patch("pato.crud.sessions._validate_session_active", new=active_mock)
@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_create_existing_collection(mock_user, mock_permissions, client):
    """Raise exception if a collection pointing to the specified folders already exist"""
    resp = client.post(
        "/proposals/cm31111/sessions/5/dataCollections",
        json=full_params,
    )
    assert resp.status_code == 400


@patch("pato.crud.sessions._validate_session_active", new=active_mock)
@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_inexistent_files(mock_user, mock_permissions, client):
    """Raise exception if raw files do not exist"""
    resp = client.post(
        "/proposals/cm31111/sessions/5/dataCollections",
        json=full_params,
    )
    assert resp.status_code == 404


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_inactive_session(mock_user, mock_permissions, client):
    """Raise exception if session is inactive"""
    resp = client.post(
        "/proposals/cm31111/sessions/5/dataCollections",
        json=full_params,
    )
    assert resp.status_code == 423
