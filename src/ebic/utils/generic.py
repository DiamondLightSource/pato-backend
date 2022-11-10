import json

from sqlalchemy import inspect


def flatten_join(tup_list):
    flattened = {}

    for inner in tup_list:
        for c in inspect(inner).mapper.column_attrs:
            flattened[c.key] = getattr(inner, c.key)

    return flattened


def parse_json_file(path):
    try:
        with open(path, "r") as file:
            return [
                {"x": i, "y": val}
                for (i, val) in enumerate(json.load(file)["data"][0]["y"])
            ]
    except (FileNotFoundError, KeyError, IndexError, TypeError):
        return []
