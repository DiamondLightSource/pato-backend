from typing import Optional

from sqlalchemy import and_
from sqlalchemy import func as f
from sqlalchemy.orm import Query

from ..models.response import DataCollectionSummaryOut, ProposalOut, VisitOut
from ..models.table import (
    BLSession,
    DataCollection,
    Proposal,
    ProposalHasPerson,
    SessionHasPerson,
)
from ..utils.auth import AuthUser
from ..utils.database import Paged, db, paginate

# TODO: Add config file


def _concat_prop_user(user: AuthUser, query: Query):
    if bool(set([11, 26]) & set(user.permissions)):
        return query

    if 8 in user.permissions:
        return query.filter(BLSession.beamLineName.like("m__"))
    return query.filter(
        ProposalHasPerson.personId == user.id,
        ProposalHasPerson.proposalId == Proposal.proposalId,
    )


def _concat_session_user(user: AuthUser, query: Query):
    if bool(set([11, 26]) & set(user.permissions)):
        return query

    if 8 in user.permissions:
        return query.filter(BLSession.beamLineName.like("m__"))

    return query.filter(
        SessionHasPerson.sessionId == BLSession.sessionId,
        SessionHasPerson.personId == user.id,
    )


def _concat_collection_user(user: AuthUser, query: Query):
    if bool(set([11, 26]) & set(user.permissions)):
        return query

    if 8 in user.permissions:
        return query.join(
            BLSession, BLSession.sessionId == DataCollection.SESSIONID
        ).filter(BLSession.beamLineName.like("m__"))

    return query.filter(
        SessionHasPerson.sessionId == DataCollection.SESSIONID,
        SessionHasPerson.personId == user.id,
    )


def get_proposals(
    items: int, page: int, search: str, user: AuthUser
) -> Paged[ProposalOut]:
    cols = [c for c in Proposal.__table__.columns if c.name != "externalId"]
    query = _concat_prop_user(
        user,
        db.session.query(
            *cols,
            f.count(BLSession.sessionId).label("visits"),
            f.count(Proposal.proposalId).over().label("total")
        )
        .filter(Proposal.proposalNumber.contains(search))
        .join(BLSession, BLSession.proposalId == Proposal.proposalId)
        .group_by(Proposal.proposalId),
    )

    return paginate(query, items, page)


def get_visits(
    items: int,
    page: int,
    user: AuthUser,
    id: Optional[str],
    search: str,
    min_date: Optional[str],
    max_date: Optional[str],
) -> Paged[VisitOut]:
    query = db.session.query(
        *[c for c in BLSession.__table__.columns],
        f.count(BLSession.sessionId).over().label("total")
    )

    if id is not None:
        query = (
            query.select_from(Proposal)
            .filter(
                and_(Proposal.proposalCode == id[:2], Proposal.proposalNumber == id[2:])
            )
            .join(BLSession, BLSession.proposalId == Proposal.proposalId)
        )

    if min_date is not None and max_date is not None:
        query = query.filter(and_(BLSession.startDate.between(min_date, max_date)))

    query = _concat_session_user(
        user, query.filter(BLSession.visit_number.contains(search))
    )

    return paginate(query, items, page)


def get_collections(
    items: int, page: int, id: int, user: AuthUser
) -> Paged[DataCollectionSummaryOut]:
    query = db.session.query(
        DataCollection.startTime,
        DataCollection.comments,
        DataCollection.dataCollectionId,
        DataCollection.SESSIONID,
        f.count(DataCollection.dataCollectionId).over().label("total"),
    ).where(id == DataCollection.SESSIONID)

    return paginate(_concat_collection_user(user, query), items, page)
