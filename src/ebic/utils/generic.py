from sqlalchemy import inspect


def flatten_join(tup_list):
    flattened = {}

    for inner in tup_list:
        for c in inspect(inner).mapper.column_attrs:
            flattened[c.key] = getattr(inner, c.key)

    return flattened
