import json
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from smtplib import SMTP

from lims_utils.auth import GenericUser
from lims_utils.tables import BLSession, DataCollectionGroup, Person, Proposal
from sqlalchemy import select, update

from ..models.alerts import (
    ALERT_FIELDS,
    ALERT_REGISTRATION_TEMPLATE,
    REGISTRATION_VALUE_ROW,
    NotificationSignup,
)
from ..utils.config import Config
from ..utils.database import db, unravel
from ..utils.generic import get_alerts_frontend_url, pascal_case_to_title
from ..utils.pika import PikaPublisher


def sign_up_for_alerts(
    user: GenericUser,
    group_id: int,
    parameters: NotificationSignup,
):
    db.session.execute(
        update(Person)
        .filter(Person.personId == user.id)
        .values({"emailAddress": parameters.email})
    )

    db.session.commit()

    session = db.session.execute(
        select(*unravel(BLSession), Proposal.proposalCode, Proposal.proposalNumber)
        .select_from(DataCollectionGroup)
        .join(BLSession)
        .join(Proposal)
        .filter(DataCollectionGroup.dataCollectionGroupId == group_id)
        .group_by(BLSession)
    ).one()

    alert_params = parameters.model_dump(exclude={"email"}, exclude_unset=True)

    with PikaPublisher() as pika_publisher:
        pika_publisher.publish(
            json.dumps({**alert_params, "dcg": group_id, "register": "pato"}),
            f"murfey_feedback_{session.beamLineName}",
        )

    proposal_reference = f"{session.proposalCode}{session.proposalNumber}"
    session_reference = f"{proposal_reference}-{session.visit_number}"

    alert_rows = ""

    msg = MIMEMultipart("alternative")
    msg["Subject"] = f"Pipeline alerts activated for {session_reference} - {group_id}"
    msg["From"] = Config.facility.contact_email

    for value in ALERT_FIELDS:
        if (
            alert_params.get(value + "Min") is not None
            or alert_params.get(value + "Max") is not None
        ):
            alert_rows += REGISTRATION_VALUE_ROW.safe_substitute(
                name=pascal_case_to_title(value),
                min=alert_params.get(value + "Min", ""),
                max=alert_params.get(value + "Max", ""),
            )

    message_body = ALERT_REGISTRATION_TEMPLATE.safe_substitute(
        session=session_reference,
        dcg=group_id,
        value_rows=alert_rows,
        pato_link=get_alerts_frontend_url(proposal_reference, session.visit_number),
    )

    # TODO: make pure, plain no-HTML message body
    msg_p1 = MIMEText(message_body, "plain")
    msg_p2 = MIMEText(message_body, "html")

    msg.attach(msg_p1)
    msg.attach(msg_p2)

    with SMTP(Config.facility.smtp_server, Config.facility.smtp_port) as smtp:
        r_msg = msg
        r_msg["To"] = parameters.email

        smtp.sendmail(Config.facility.contact_email, parameters.email, r_msg.as_string())
