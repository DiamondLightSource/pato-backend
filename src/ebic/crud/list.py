from typing import Optional

from sqlalchemy import and_
from sqlalchemy import func as f
from sqlalchemy.orm import Query

from ..models.response import DataCollectionSummaryOut, ProposalOut, VisitOut
from ..models.table import BLSession, DataCollection, Proposal, ProposalHasPerson
from ..utils.database import Paged, db, paginate


def _concat_prop_user(user: dict, query: Query):
    if not user["is_admin"]:
        return query.filter(
            ProposalHasPerson.personId == user["id"].personId,
            ProposalHasPerson.proposalId == Proposal.proposalId,
        )
    return query


def get_proposals(items: int, page: int, search: str, user: dict) -> Paged[ProposalOut]:
    cols = [c for c in Proposal.__table__.columns if c.name != "externalId"]
    query = _concat_prop_user(
        user,
        db.session.query(*cols, f.count(BLSession.sessionId).label("visits"))
        .filter(Proposal.proposalNumber.contains(search))
        .join(BLSession, BLSession.proposalId == Proposal.proposalId)
        .group_by(Proposal.proposalId),
    )

    query = paginate(
        query,
        items,
        page,
    )

    count = (
        _concat_prop_user(user, db.session.query(f.count(Proposal.proposalId)))
        .filter(Proposal.proposalNumber.contains(search))
        .first()[0]
        or 0
    )

    return Paged(items=query.all(), total=count, limit=items, page=page)


def get_visits(
    items: int,
    page: int,
    user: dict,
    id: Optional[str],
    search: str,
    min_date: Optional[str],
    max_date: Optional[str],
) -> Paged[VisitOut]:
    query = db.session.query(BLSession)

    count_query = db.session.query(f.count(BLSession.sessionId))
    if id is not None:
        query = (
            query.select_from(Proposal)
            .filter(
                and_(Proposal.proposalCode == id[:2], Proposal.proposalNumber == id[2:])
            )
            .join(BLSession, BLSession.proposalId == Proposal.proposalId)
        )
        count_query = count_query.filter(BLSession.proposalId == id)

    if min_date is not None and max_date is not None:
        query = query.filter(and_(BLSession.startDate.between(min_date, max_date)))
        count_query = count_query.filter(
            BLSession.startDate.between(min_date, max_date)
        )

    query = paginate(query.filter(BLSession.visit_number.contains(search)), items, page)

    count = count_query.filter(BLSession.visit_number.contains(search)).first()[0] or 0

    return Paged(items=query.all(), total=count, limit=items, page=page)


def get_collections(items: int, page: int, id: int) -> Paged[DataCollectionSummaryOut]:
    query = paginate(
        db.session.query(
            DataCollection.startTime,
            DataCollection.comments,
            DataCollection.dataCollectionId,
            DataCollection.SESSIONID,
        ).where(id == DataCollection.SESSIONID),
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
