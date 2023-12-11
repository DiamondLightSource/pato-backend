import datetime
import json
from os.path import isfile
from typing import Optional

from fastapi import HTTPException
from pydantic import BaseModel

from ..models.response import DataPoint
from ..utils.config import Config
from ..utils.logging import app_logger


def parse_json_file(path):
    try:
        with open(path, "r") as file:
            data = json.load(file)["data"][0]
            return [
                DataPoint(x=x_val, y=y_val)
                for (x_val, y_val) in zip(data["x"], data["y"])
            ]
    except (FileNotFoundError, KeyError, IndexError, TypeError):
        return []
    except json.decoder.JSONDecodeError:
        raise HTTPException(
            status_code=500,
            detail="JSON file not in correct format",
        )


def validate_path(func):
    def wrap(*args, **kwargs):
        try:
            file = func(*args, **kwargs)
            if not file:
                raise ValueError
        except (ValueError, TypeError):
            app_logger.error(
                "File not in table when executing %s with arguments %s",
                func.__name__,
                args,
            )
            raise HTTPException(
                status_code=404,
                detail="No file found in table",
            )

        if not isfile(file):
            app_logger.error(
                "%s not in filesystem when executing %s with arguments %s",
                file,
                func.__name__,
                args,
            )
            raise HTTPException(
                status_code=404,
                detail="File does not exist in filesystem",
            )
        return file

    return wrap


def filter_dict(original_dict: dict, filter: list[str]):
    return {key: value for key, value in original_dict.items() if key not in filter}


def time_ago(delta: datetime.timedelta):
    today = datetime.date.today()
    return today - delta


def check_session_active(end_date: Optional[datetime.datetime]):
    return (
        end_date.date()
        > time_ago(datetime.timedelta(weeks=Config.facility.active_session_cutoff))
        if end_date
        else False
    )


class ProposalReference(BaseModel):
    code: str
    number: int
    visit_number: int | None = None


def parse_proposal(proposalReference: str, visit_number: int | None = None):
    try:
        return ProposalReference(
            code=proposalReference[0:2],
            number=int(proposalReference[2:]),
            visit_number=visit_number,
        )
    except ValueError:
        raise ValueError("Proposal reference must be formatted as aa12345")
