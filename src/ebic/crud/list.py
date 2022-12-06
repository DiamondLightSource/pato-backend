from operator import or_
from typing import Optional

from sqlalchemy import and_
from sqlalchemy import func as f
from sqlalchemy.orm import Query

from ..models.response import DataCollectionGroupSummaryOut, ProposalOut, VisitOut
from ..models.table import (
    BLSession,
    DataCollection,
    DataCollectionGroup,
    Proposal,
    ProposalHasPerson,
    SessionHasPerson,
)
from ..utils.auth import User, is_admin, is_em_staff
from ..utils.database import Paged, db, paginate

# TODO: Add config file


def check_admin(func):
    def wrap(*args, **kwargs):
        user = args[0]
        query = args[1]

        if is_admin(user.permissions):
            return query

        return func(*args, **kwargs)

    return wrap


@check_admin
def _concat_prop_user(user: User, query: Query):
    if is_em_staff(user.permissions):
        return query.filter(BLSession.beamLineName.like("m__"))
    return query.filter(
        ProposalHasPerson.personId == user.id,
        ProposalHasPerson.proposalId == Proposal.proposalId,
    )


@check_admin
def _concat_session_user(user: User, query: Query):
    if is_em_staff(user.permissions):
        return query.filter(BLSession.beamLineName.like("m__"))

    return query.filter(
        SessionHasPerson.sessionId == BLSession.sessionId,
        SessionHasPerson.personId == user.id,
    )


@check_admin
def _concat_collection_group_user(user: User, query: Query):
    if is_em_staff(user.permissions):
        return query.join(
            BLSession, BLSession.sessionId == DataCollectionGroup.sessionId
        ).filter(BLSession.beamLineName.like("m__"))

    return query.filter(
        SessionHasPerson.sessionId == DataCollectionGroup.sessionId,
        SessionHasPerson.personId == user.id,
    )


def get_proposals(items: int, page: int, search: str, user: User) -> Paged[ProposalOut]:
    cols = [c for c in Proposal.__table__.columns if c.name != "externalId"]
    query = _concat_prop_user(
        user,
        db.session.query(
            *cols,
            f.count(BLSession.sessionId).label("visits"),
            f.count(Proposal.proposalId).over().label("total"),
        )
        .filter(
            f.concat(Proposal.proposalCode, Proposal.proposalNumber).contains(search)
        )
        .join(BLSession)
        .group_by(Proposal.proposalId),
    )

    return paginate(query, items, page)


def get_visits(
    items: int,
    page: int,
    user: User,
    id: Optional[str],
    search: str,
    min_date: Optional[str],
    max_date: Optional[str],
) -> Paged[VisitOut]:
    query = db.session.query(
        *[c for c in BLSession.__table__.columns],
        f.count(BLSession.sessionId).over().label("total"),
    )

    if id is not None:
        query = (
            query.select_from(Proposal)
            .filter(
                and_(Proposal.proposalCode == id[:2], Proposal.proposalNumber == id[2:])
            )
            .join(BLSession)
        )

    if min_date is not None and max_date is not None:
        query = query.filter(and_(BLSession.startDate.between(min_date, max_date)))

    query = _concat_session_user(
        user,
        query.filter(BLSession.visit_number.contains(search)).order_by(
            BLSession.visit_number
        ),
    )

    return paginate(query, items, page)


def get_collection_groups(
    items: int, page: int, id: int, search: str, user: User
) -> Paged[DataCollectionGroupSummaryOut]:
    query = (
        db.session.query(
            *[c for c in DataCollectionGroup.__table__.columns],
            f.count(DataCollectionGroup.dataCollectionGroupId).over().label("total"),
            f.count(DataCollection.dataCollectionId).label("collections"),
        )
        .where(
            and_(
                id == DataCollectionGroup.sessionId == id,
                or_(
                    DataCollectionGroup.comments.contains(search),
                    search == "",
                ),
            )
        )
        .join(
            DataCollection,
            DataCollection.dataCollectionGroupId
            == DataCollectionGroup.dataCollectionGroupId,
        )
        .group_by(DataCollectionGroup.dataCollectionGroupId)
    )

    return paginate(_concat_collection_group_user(user, query), items, page)
