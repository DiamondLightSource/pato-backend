from datetime import datetime
from unittest.mock import mock_open, patch

from lims_utils.tables import BLSession

VALID_FILE = b"\x00" * 208 + b"\x4d\x41\x50"


def active_mock(_):
    return BLSession(
        startDate=datetime(year=2022, month=1, day=1),
        sessionId=27464088,
        beamLineName="m12",
    )


@patch("pato.crud.sessions._validate_session_active", new=active_mock)
@patch("builtins.open", new_callable=mock_open())
@patch("pato.crud.sessions.os.path.isdir", new=lambda _: True)
def test_post(_, mock_permissions, client):
    """Should write file successfully if file matches expected signature"""
    resp = client.post(
        "/proposals/cm31111/sessions/5/initialModel",
        files={"file": ("mrc.mrc", VALID_FILE, "application/octet-stream")},
    )

    assert resp.status_code == 200


@patch("pato.crud.sessions._validate_session_active", new=active_mock)
@patch("builtins.open", new_callable=mock_open())
def test_invalid_file_signature(_, mock_permissions, client):
    """Should raise exception if file signature doesn't match MRC file signature"""
    resp = client.post(
        "/proposals/cm31111/sessions/5/initialModel",
        files={"file": ("not-mrc.mrc", b"\x01\x02", "application/octet-stream")},
    )

    assert resp.status_code == 415


@patch("pato.crud.sessions._validate_session_active", new=active_mock)
@patch("builtins.open", side_effect=OSError("Write Error"))
@patch("pato.crud.sessions.os.path.isdir", new=lambda _: True)
def test_write_error(_, mock_permissions, client):
    """Should return 500 if there was an error writing the file"""
    resp = client.post(
        "/proposals/cm31111/sessions/5/initialModel",
        files={"file": ("mrc.mrc", VALID_FILE, "application/octet-stream")},
    )

    assert resp.status_code == 500


@patch("pato.crud.sessions._validate_session_active", new=active_mock)
@patch("builtins.open", side_effect=OSError("Write Error"))
@patch("pato.crud.sessions.os.path.isdir", new=lambda _: False)
def test_dir_does_not_exist(_, mock_permissions, client):
    """Should return 500 if directory does not exist"""
    resp = client.post(
        "/proposals/cm31111/sessions/5/initialModel",
        files={"file": ("mrc.mrc", VALID_FILE, "application/octet-stream")},
    )

    assert resp.status_code == 500
