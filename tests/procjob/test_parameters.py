from unittest.mock import patch


def test_get(mock_permissions, client):
    """Get all processing job parameters for job"""
    resp = client.get("/processingJob/5/parameters")
    assert resp.status_code == 200
    assert resp.json() == {
        "items": {"vortex factor": "1.8*10^102", "80s factor": "0.87*10^-93"},
        "allowReprocessing": False,
    }


def test_inexistent(mock_permissions, client):
    """Try to get processing job parameters for job that doesn't exist"""
    resp = client.get("/processingJob/0/parameters")
    assert resp.status_code == 404


def test_inactive_session(mock_permissions, client):
    """Get processing parameters for inactive session"""
    with patch("pato.crud.procjob.check_session_active") as patched_session_check:
        patched_session_check.return_value = False
        resp = client.get("/processingJob/5/parameters")
        assert resp.status_code == 200
        assert resp.json() == {
            "items": {"vortex factor": "1.8*10^102", "80s factor": "0.87*10^-93"},
            "allowReprocessing": False,
        }


def test_active_session(mock_permissions, client):
    """Get processing parameters for active session"""
    with patch("pato.crud.procjob.check_session_active") as patched_session_check:
        patched_session_check.return_value = True
        resp = client.get("/processingJob/5/parameters")
        assert resp.status_code == 200
        assert resp.json() == {
            "items": {"vortex factor": "1.8*10^102", "80s factor": "0.87*10^-93"},
            "allowReprocessing": True,
        }
