import json
import os
from typing import Collection, Optional

_defaults = {
    "auth": {
        "endpoint": "http://localhost:8050/",
        "read_all_perms": [11, 26],
        "read_em_perms": [8],
        "type": "micro",
    },
    "ispyb": {"pool": 10, "overflow": 20},
}


class Config:
    __conf: dict | None = None

    @staticmethod
    def get() -> Optional[Collection[object]]:
        if Config.__conf is None:
            try:
                with open(os.environ.get("CONFIG_PATH") or "config.json", "r") as fp:
                    Config.__conf = json.load(fp)
            except FileNotFoundError:
                Config.__conf = _defaults

        return Config.__conf
