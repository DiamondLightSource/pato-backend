import json
import os
from dataclasses import dataclass, field
from typing import Literal


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


class Config:
    auth: Auth
    ispyb: ISPyB

    @staticmethod
    def set():
        try:
            with open(os.environ.get("CONFIG_PATH") or "config.json", "r") as fp:
                conf = json.load(fp)
                Config.auth = Auth(**conf["auth"])
                Config.ispyb = ISPyB(**conf["ispyb"])
        except (FileNotFoundError, KeyError):
            pass
