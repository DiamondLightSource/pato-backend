from unittest.mock import patch

import pytest

from ..users import admin


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_inactive_session(mock_user, mock_permissions, client):
    """Check if reprocessing is allowed for inactive session"""
    with patch("pato.crud.sessions.check_session_active") as patched_session_check:
        patched_session_check.return_value = False
        resp = client.get("/proposals/cm14451/sessions/1/reprocessingEnabled")
        assert resp.status_code == 200
        assert resp.json() == {
            "allowReprocessing": False,
        }


@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_active_session(mock_user, mock_permissions, client):
    """Check if reprocessing is allowed for active session"""
    with patch("pato.crud.sessions.check_session_active") as patched_session_check:
        patched_session_check.return_value = True
        resp = client.get("/proposals/cm14451/sessions/1/reprocessingEnabled")
        assert resp.status_code == 200
        assert resp.json() == {
            "allowReprocessing": True,
        }
