from unittest.mock import ANY, patch

from pato.utils.config import Config
from pato.utils.email import email_consumer


def test_send_email(client):
    """Should send emails for all users in provided session"""
    with patch("pato.utils.email.SMTP", autospec=True) as mock_smtp:
        email_consumer(None, None, None, b'{"groupId": 988855, "message": "test"}')

        ctx = mock_smtp.return_value.__enter__.return_value
        ctx.sendmail.assert_called_with(Config.facility.contact_email, "boaty@diamond.ac.uk", ANY)


def test_malformed(client, caplog):
    """Should log error if malformed message is sent"""
    email_consumer(None, None, None, b"not-valid")
    assert "Malformed email message provided: b'not-valid'" in caplog.text


def test_no_recipients(client, caplog):
    """Should log error if no recipients are available"""
    email_consumer(None, None, None, b'{"groupId": 5440741, "message": "test"}')
    assert "Data collection group 5440741 has no associated users with valid emails" in caplog.text
