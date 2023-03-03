import json
import os
from dataclasses import dataclass, field
from typing import Literal


class ConfigurationError(Exception):
    pass


@dataclass
class Auth:
    endpoint: str = "https://localhost/auth"
    type: Literal["oidc", "dummy", "micro"] = "micro"
    read_all_perms: list[int] = field(default_factory=lambda: [11, 26])
    read_em_perms: list[int] = field(default_factory=lambda: [8])
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

    @staticmethod
    def set():
        try:
            with open(os.environ.get("CONFIG_PATH") or "config.json", "r") as fp:
                conf = json.load(fp)
                Config.auth = Auth(**conf["auth"])
                Config.ispyb = ISPyB(**conf["ispyb"])
                Config.mq = MQ(**conf["mq"])

                Config.mq.user = os.environ["MQ_USER"]
                Config.mq.password = os.environ["MQ_PASS"]
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
