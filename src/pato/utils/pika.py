import json
import socket
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from smtplib import SMTP
from typing import Any, Callable

import pika
from lims_utils.database import get_session
from lims_utils.logging import app_logger
from lims_utils.tables import (
    BLSession,
    DataCollectionGroup,
    Person,
    Proposal,
    SessionHasPerson,
)
from pika.channel import Channel
from pydantic import ValidationError
from sqlalchemy import func, select

from ..models.alerts import ALERT_EMAIL_TEMPLATE, EmailNotification
from ..utils.config import Config
from ..utils.generic import get_alerts_frontend_url
from .database import session_factory

_credentials = pika.PlainCredentials(Config.mq.user, Config.mq.password)
_parameters = pika.ConnectionParameters(
    Config.mq.host,
    Config.mq.port,
    credentials=_credentials,
    virtual_host=Config.mq.vhost,
)
_headers = {"zocalo.go.user": Config.mq.user, "zocalo.go.host": socket.gethostname()}
_properties = pika.BasicProperties(headers=_headers, delivery_mode=2)


class PikaConsumer:
    def __init__(self, *args, **kwargs):
        self.conn = pika.BlockingConnection(_parameters)
        self.channel = self.conn.channel()
        self.channel.exchange_declare(
            exchange=Config.mq.consumer_queue, exchange_type="topic"
        )

    def consume(
        self,
        key: str,
        callback: Callable[[Channel, Any, pika.BasicProperties, bytes], None],
    ):
        result = self.channel.queue_declare(Config.mq.consumer_queue, exclusive=True)
        queue = result.method.queue
        self.channel.queue_bind(
            exchange=Config.mq.consumer_queue, queue=queue, routing_key=key
        )

        self.channel.basic_consume(
            queue=queue, on_message_callback=callback, auto_ack=True
        )

        self.channel.start_consuming()

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        self.conn.close()


def _email_consumer(_, _1, _2, body: bytes):
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

    msg = MIMEMultipart("alternative")
    msg["Subject"] = f"Alert for session {session_reference}"
    msg["From"] = Config.facility.contact_email

    msg_p1 = MIMEText(notification.message, "plain")
    msg_p2 = MIMEText(
        ALERT_EMAIL_TEMPLATE.safe_substitute(
            msg=notification.message,
            pato_link=get_alerts_frontend_url(session.proposal, session.visit_number),
        ),
        "html",
    )

    msg.attach(msg_p1)
    msg.attach(msg_p2)

    with SMTP(Config.facility.smtp_server, Config.facility.smtp_port) as smtp:
        for recipient in recipients:
            r_msg = msg
            r_msg["To"] = recipient

            smtp.sendmail(Config.facility.contact_email, recipient, msg.as_string())


def start_email_consumer():
    with PikaConsumer() as consumer:
        consumer.consume(Config.mq.consumer_queue, _email_consumer)


class PikaPublisher:
    def __init__(self, exchange=""):
        self.conn = pika.BlockingConnection(_parameters)
        self.channel = self.conn.channel()

    def publish(self, message, queue=Config.mq.queue):
        self.channel.basic_publish(
            routing_key=queue,
            body=message,
            mandatory=True,
            properties=_properties,
            exchange="",
        )

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        self.conn.close()
