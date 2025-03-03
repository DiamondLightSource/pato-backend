import datetime
import json
import re
from os.path import isfile
from typing import Literal, Optional

from fastapi import HTTPException, status
from lims_utils.logging import app_logger
from pydantic import BaseModel
from sqlalchemy import literal_column

from ..models.response import DataPoint, ItemList
from ..utils.config import Config
from .database import db

# TODO: use 'type' when supported by Mypy
MovieType = Literal["denoised", "segmented", "picked"] | None


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


def filter_model(original: BaseModel, filter: list[str]):
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
    assert (
        len(proposalReference) > 2
    ), "Proposal reference must be at least 3 characters long"

    code = proposalReference[0:2]
    number = proposalReference[2:]

    assert code.isalpha(), "Proposal code must be a two letter code"
    assert number.isdigit(), "Proposal number must be a valid integer"

    return ProposalReference(
        code=code,
        number=int(number),
        visit_number=visit_number,
    )


def parse_count(query):
    """Get mappings from query, return keys/values in graph format"""
    data = db.session.execute(query.order_by(literal_column("1"))).mappings().one()
    if not any(value != 0 for value in data.values()):
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No items found",
        )

    return ItemList[DataPoint](
        items=[{"x": key, "y": value} for (key, value) in dict(data).items()]
    )


def pascal_case_to_title(string: str) -> str:
    return " ".join(re.split("(?<=.)(?=[A-Z])", string)).title()


def get_alerts_frontend_url(proposal_reference: str, visit_number: int):
    """Build URL pointing to alerts management page in PATo's frontend

    Args:
        proposal_reference: Proposal Reference
        visit_number: Visit number

    Returns:
        Built URL"""
    return f"{Config.facility.frontend_url}/proposals/{proposal_reference}/sessions/{visit_number}/alerts"
