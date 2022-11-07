from sqlalchemy import and_
from sqlalchemy import func as f

from ..models.response import ProposalOut, VisitOut
from ..models.table import BLSession, DataCollection, Proposal
from ..utils.database import Paged, db, paginate

# TODO: Add a wrapper to avoid boilerplate code


def get_all_proposals(items: int, page: int, search: str = "") -> Paged[ProposalOut]:
    cols = [c for c in Proposal.__table__.columns if c.name != "externalId"]
    query = paginate(
        db.session.query(*cols, f.count(BLSession.sessionId).label("visits"))
        .filter(Proposal.proposalNumber.contains(search))
        .join(BLSession, BLSession.proposalId == Proposal.proposalId)
        .group_by(Proposal.proposalId),
        items,
        page,
    )

    count = (
        db.session.query(f.count(Proposal.proposalId))
        .filter(Proposal.proposalNumber.contains(search))
        .first()[0]
        or 0
    )

    return Paged(items=query.all(), total=count, limit=items, page=page)


def get_all_visits(
    items: int = None,
    page: int = 1,
    id: int = None,
    min_date: str = None,
    max_date: str = None,
) -> Paged[VisitOut]:
    query = db.session.query(BLSession)

    count_query = db.session.query(f.count(BLSession.sessionId))

    if id is not None:
        query = query.filter(BLSession.proposalId == id)
        count_query = count_query.filter(BLSession.proposalId == id)

    if min_date is not None and max_date is not None:
        query = query.filter(and_(BLSession.startDate.between(min_date, max_date)))
        count_query = count_query.filter(
            BLSession.startDate.between(min_date, max_date)
        )

    if items is not None:
        query = paginate(query, items, page)

    count = count_query.first()[0] or 0

    return Paged(items=query.all(), total=count, limit=items, page=page)


def get_all_collections(items: int, page: int, id: int) -> Paged[DataCollection]:
    query = paginate(
        db.session.query(DataCollection).where(id == DataCollection.SESSIONID),
        items,
        page,
    )

    count = (
        db.session.query(f.count(DataCollection.dataCollectionId))
        .where(id == DataCollection.SESSIONID)
        .first()[0]
        or 0
    )

    return Paged(items=query.all(), total=count, limit=items, page=page)
