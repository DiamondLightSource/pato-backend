import datetime
import json
from os.path import isfile
from typing import Optional

from fastapi import HTTPException, status
from lims_utils.logging import app_logger
from pydantic import BaseModel

from ..models.response import DataPoint
from ..utils.config import Config


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


def filter_dict(original: BaseModel, filter: list[str]):
    for key in original.model_fields.keys():
        if key in filter:
            setattr(original, key, None)

    return original


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
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail="Proposal reference must be formatted as aa12345",
        )
