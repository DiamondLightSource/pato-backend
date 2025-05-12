import json
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from smtplib import SMTP

from lims_utils.database import get_session
from lims_utils.logging import app_logger
from lims_utils.tables import (
    BLSession,
    DataCollectionGroup,
    Person,
    Proposal,
    SessionHasPerson,
)
from pydantic import ValidationError
from sqlalchemy import func, select

from ..assets.paths import COMPANY_LOGO_LIGHT
from ..models.alerts import (
    EMAIL_FOOTER,
    EMAIL_HEADER,
    EmailNotification,
)
from ..utils.config import Config
from ..utils.database import session_factory
from ..utils.generic import get_alerts_frontend_url


def create_email(
    msg_body: str, subject: str, proposal_reference: str, visit_number: int
):
    """Create email with standard header/footers.

    Args:
        msg_body: Body of the message to send
        subject: Subject of the message
        proposal_reference: Proposal reference associated with the message (e.g.:cm12345)
        visit_number: Visit number associated with the message

    Returns:
        Multipart message object
    """
    # Normally, a single multipart email would work, but Microsoft Outlook won't display images properly unless
    # they are encased in a 'related' multipart wrapper
    msg_root = MIMEMultipart("related")
    msg_root["Subject"] = subject
    msg_root["From"] = Config.facility.contact_email

    msg = MIMEMultipart("alternative")

    msg_p1 = MIMEText(msg_body, "plain")
    msg_p2 = MIMEText(
        EMAIL_HEADER
        + msg_body
        + EMAIL_FOOTER.safe_substitute(
            pato_link=get_alerts_frontend_url(proposal_reference, visit_number)
        ),
        "html",
    )

    msg.attach(msg_p1)
    msg.attach(msg_p2)

    with open(COMPANY_LOGO_LIGHT, "rb") as image_file:
        img = MIMEImage(image_file.read(), "png")

    img.add_header("Content-ID", "<logo-light.png>")
    # Microsoft Outlook treats the first part as an email and the other ones as attachments.
    # This means the order here matters
    msg_root.attach(msg)
    msg_root.attach(img)

    return msg_root


def email_consumer(_, _1, _2, body: bytes):
    """Consume RabbitMQ message, and send out emails to all personnel in the data collection group."""
    app_logger.info("Received notification request: %s", body)
    try:
        json_body = json.loads(body)
        notification = EmailNotification.model_validate(json_body)
    except (json.decoder.JSONDecodeError, ValidationError):
        app_logger.error("Malformed email message provided: %s", body)
        return

    with get_session(session_factory) as db_session:
        recipients = db_session.scalars(
            select(Person.emailAddress)
            .select_from(DataCollectionGroup)
            .join(BLSession)
            .join(SessionHasPerson)
            .join(Person)
            .filter(
                DataCollectionGroup.dataCollectionGroupId == notification.groupId,
                Person.emailAddress.is_not(None),
            )
        ).all()

        session = db_session.execute(
            select(
                func.concat(Proposal.proposalCode, Proposal.proposalNumber).label(
                    "proposal"
                ),
                BLSession.visit_number,
            )
            .select_from(DataCollectionGroup)
            .join(BLSession)
            .join(Proposal)
            .filter(DataCollectionGroup.dataCollectionGroupId == notification.groupId)
        ).one()

    if recipients is None or len(recipients) == 0:
        app_logger.error(
            "Data collection group %i has no associated users with valid emails",
            notification.groupId,
        )
        return

    session_reference = f"{session.proposal}-{session.visit_number}"

    msg = create_email(
        notification.message,
        f"Alert for session {session_reference}",
        session.proposal,
        session.visit_number,
    )

    with SMTP(Config.facility.smtp_server, Config.facility.smtp_port) as smtp:
        for recipient in recipients:
            r_msg = msg
            r_msg["To"] = recipient

            smtp.sendmail(Config.facility.contact_email, recipient, msg.as_string())
