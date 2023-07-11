import json
import os
from dataclasses import dataclass, field
from typing import Literal


class ConfigurationError(Exception):
    pass


@dataclass
class Facility:
    contact_email: str
    smtp_server: str
    smtp_port: int = 587


@dataclass
class Auth:
    endpoint: str = "https://localhost/auth"
    type: Literal["dummy", "micro"] = "micro"
    read_all_perms: list[str] = field(default_factory=lambda: ["super_admin"])
    beamline_mapping: dict[str, list[str]] = field(default_factory=lambda: {})


@dataclass
class ISPyB:
    pool: int = 10
    overflow: int = 20


@dataclass
class MQ:
    host: str
    port: int
    queue: str
    user: str = "guest"
    password: str = "guest"


class Config:
    auth: Auth
    ispyb: ISPyB
    mq: MQ
    facility: Facility

    @staticmethod
    def set():
        try:
            with open(os.environ.get("CONFIG_PATH") or "config.json", "r") as fp:
                conf = json.load(fp)
                Config.auth = Auth(**conf["auth"])
                Config.ispyb = ISPyB(**conf["ispyb"])
                Config.mq = MQ(**conf["mq"])
                Config.facility = Facility(**conf["facility"])

                Config.mq.user = os.environ.get("MQ_USER")
                Config.mq.password = os.environ.get("MQ_PASS")
        except (FileNotFoundError, TypeError) as exc:
            raise ConfigurationError(str(exc).replace(".__init__()", "")) from exc
        except KeyError as exc:
            msg = str(exc)
            if msg.isupper():
                raise ConfigurationError(f"Environment variable {str(exc)} is missing")
            else:
                raise ConfigurationError(
                    f"Key {str(exc)} missing from configuration file"
                )
