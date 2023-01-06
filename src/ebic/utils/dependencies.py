from fastapi import Query


def pagination(
    page: int = Query(
        0,
        description=(
            "Page number/Results to skip. Negative numbers count backwards from "
            "the last page"
        ),
    ),
    limit: int = Query(25, gt=0, description="Number of results to show"),
) -> dict[str, int]:
    return {"page": page, "limit": limit}
