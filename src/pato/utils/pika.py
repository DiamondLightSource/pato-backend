import socket
from typing import Any, Callable

import pika
from pika.channel import Channel

from .config import Config
from .email import email_consumer

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
        result = self.channel.queue_declare(
            Config.mq.consumer_queue,
            exclusive=False,
            durable=True,
            arguments=Config.mq.arguments,
        )
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

def start_email_consumer():
    with PikaConsumer() as consumer:
        consumer.consume(Config.mq.consumer_queue, email_consumer)


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
