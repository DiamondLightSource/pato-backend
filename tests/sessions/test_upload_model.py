from datetime import datetime
from unittest.mock import mock_open, patch

from lims_utils.tables import BLSession

VALID_FILE = b"\x89\x48\x44\x46\x0d\x0a\x1a\x0a\x01\x02\x03"


def active_mock(_):
    return BLSession(
        startDate=datetime(year=2022, month=1, day=1),
        sessionId=27464088,
        beamLineName="m12",
    )


@patch("pato.crud.sessions._validate_session_active", new=active_mock)
@patch("builtins.open", new_callable=mock_open())
def test_post(_, mock_permissions, client):
    """Should write file successfully if first 8 bytes match expected signature"""
    resp = client.post(
        "/proposals/cm31111/sessions/5/processingModel",
        files={"file": ("h5.h5", VALID_FILE, "application/octet-stream")},
    )

    assert resp.status_code == 200


@patch("pato.crud.sessions._validate_session_active", new=active_mock)
@patch("builtins.open", new_callable=mock_open())
def test_invalid_file_signature(_, mock_permissions, client):
    """Should raise exception if file signature doesn't match HDF5 file signature"""
    resp = client.post(
        "/proposals/cm31111/sessions/5/processingModel",
        files={"file": ("not-h5.h5", b"\x01\x02", "application/octet-stream")},
    )

    assert resp.status_code == 415


@patch("pato.crud.sessions._validate_session_active", new=active_mock)
@patch("builtins.open", side_effect=OSError("Write Error"))
def test_write_error(_, mock_permissions, client):
    """Should return 500 if there was an error writing the file"""
    resp = client.post(
        "/proposals/cm31111/sessions/5/processingModel",
        files={"file": ("not-h5.h5", VALID_FILE, "application/octet-stream")},
    )

    assert resp.status_code == 500
