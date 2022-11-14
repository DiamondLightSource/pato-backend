import json

from sqlalchemy import inspect


def flatten_join(tup_list, preserve_dups=[]):
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
                {"x": i, "y": val}
                for (i, val) in enumerate(json.load(file)["data"][0]["y"])
            ]
    except (FileNotFoundError, KeyError, IndexError, TypeError):
        return []
