import socket
from contextlib import contextmanager

import pika

from ..utils.config import Config

_credentials = pika.PlainCredentials(Config.mq.user, Config.mq.password)
_parameters = pika.ConnectionParameters(
    Config.mq.host, Config.mq.port, credentials=_credentials
)
_hostname = socket.gethostname()


@contextmanager
def send_message(message: str):
    conn = pika.BlockingConnection(_parameters)
    channel = conn.channel()
    headers = {"zocalo.go.user": Config.mq.user, "zocalo.go.host": _hostname}

    properties = pika.BasicProperties(headers=headers, delivery_mode=2)
    try:
        channel.basic_publish(
            routing_key=Config.mq.queue,
            body=message,
            mandatory=True,
            properties=properties,
            exchange="",
        )
    finally:
        conn.close()
