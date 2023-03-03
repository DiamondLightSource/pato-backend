import socket

import pika
from pika.channel import Channel
from pika.connection import Connection

from ..utils.config import Config

_credentials = pika.PlainCredentials(Config.mq.user, Config.mq.password)
_parameters = pika.ConnectionParameters(
    Config.mq.host, Config.mq.port, credentials=_credentials
)
_headers = {"zocalo.go.user": Config.mq.user, "zocalo.go.host": socket.gethostname()}
_properties = pika.BasicProperties(headers=_headers, delivery_mode=2)


class PikaPublisher:
    def __init__(self):
        self._conn = None
        self._channel = None

    # For non-blocking connections in the future
    # Although using an async adapter would yield performance improvements if we
    # were not blocking on every request, we're blocking on every request anyways,
    # so that would be negated.
    def _on_open(self, conn: Connection):
        conn.channel(self._on_channel_open)

    def _on_channel_open(self, channel: Channel):
        self._channel = channel
        self._channel.exchange_declare(exchange="")

    def _on_close(self):
        self._conn.ioloop.start()
        self.connect()

    def connect(self):
        if self._conn is None or self._conn.is_closed:
            self._conn = pika.BlockingConnection(_parameters)
            self._channel = self._conn.channel()

    def publish(self, message):
        try:
            self._channel.basic_publish(
                routing_key=Config.mq.queue,
                body=message,
                mandatory=True,
                properties=_properties,
                exchange="",
            )
        except pika.exceptions.ConnectionClosed:
            self.connect()
            self.publish(message)


pika_publisher = PikaPublisher()
