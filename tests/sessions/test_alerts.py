import json
from unittest.mock import ANY, patch

import pytest

from pato.utils.config import Config
from tests.users import admin

full_params = {"email": "test@diamond.ac.uk", "astigmatismMin": 10}

@pytest.fixture(scope="session", autouse=False)
def mock_pika():
    with patch("pato.crud.alerts.PikaPublisher", autospec=True) as _fixture:
        _fixture.return_value.__enter__.return_value = _fixture
        yield _fixture

@pytest.mark.parametrize("mock_user", [admin], indirect=True)
def test_post(mock_pika, mock_user, mock_permissions, client):
    """Should update user email in database and send message to appropriate message queue"""
    with patch("pato.crud.alerts.SMTP", autospec=True) as mock_smtp:
        client.post(
            "/dataGroups/988855/alerts",
            json=full_params,
        )

        ctx = mock_smtp.return_value.__enter__.return_value
        ctx.sendmail.assert_called_with(Config.facility.contact_email, "test@diamond.ac.uk", ANY)

    mock_pika.publish.assert_called_with(
        json.dumps({"astigmatismMin": 10, "dcg": 988855, "register": "pato"}), "murphy_feedback_i03"
    )


def test_invalid_email(mock_permissions, client):
    """Should raise exception if invalid email is provided"""
    resp = client.post(
        "/dataGroups/988855/alerts",
        json={"email": "abc"},
    )
    assert resp.status_code == 422

    data = resp.json()
    assert data["detail"][0]["msg"] == "value is not a valid email address: An email address must have an @-sign."


def test_min_greater_than_max(mock_permissions, client):
    """Should raise exception if min value for one of the alert thresholds is greater than the max"""
    resp = client.post(
        "/dataGroups/988855/alerts",
        json={**full_params, "astigmatismMax": 5},
    )
    assert resp.status_code == 422

    data = resp.json()
    assert data["detail"][0]["msg"] == "Assertion failed, astigmatismMax must be greater than astigmatismMin"


def test_negativity(mock_permissions, client):
    """Should raise exception if resolution/particle count thresholds are negative"""
    resp = client.post(
        "/dataGroups/988855/alerts",
        json={**full_params, "resolutionMin": -1},
    )
    assert resp.status_code == 422

    data = resp.json()
    assert data["detail"][0]["msg"] == "Input should be greater than or equal to 0"
