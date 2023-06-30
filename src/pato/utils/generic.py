import json
from os.path import isfile

from fastapi import HTTPException
from sqlalchemy import inspect

from ..models.response import DataPoint
from ..utils.logging import app_logger


def flatten_join(tup_list, preserve_dups=[]):
    if tup_list is None:
        raise HTTPException(
            status_code=404,
            detail="Request did not return any data",
        )
    flattened = {}

    for inner in tup_list:
        for c in inspect(inner).mapper.column_attrs:
            key = c.key
            if c.key in preserve_dups:
                key = key + "_" + inner.__table__.name

            flattened[key] = getattr(inner, c.key)

    return flattened


def parse_json_file(path):
    try:
        with open(path, "r") as file:
            return [
                DataPoint(x=i, y=val)
                for (i, val) in enumerate(json.load(file)["data"][0]["y"])
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
