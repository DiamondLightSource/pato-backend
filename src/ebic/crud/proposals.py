from typing import Optional

from sqlalchemy import and_
from sqlalchemy import func as f
from sqlalchemy.orm import Query

from ..auth import User
from ..models.response import ProposalOut, VisitOut
from ..models.table import BLSession, Proposal, ProposalHasPerson, SessionHasPerson
from ..utils.auth import check_admin, is_em_staff
from ..utils.database import Paged, db, paginate


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


def get_proposals(items: int, page: int, search: str, user: User) -> Paged[ProposalOut]:
    cols = [c for c in Proposal.__table__.columns if c.name != "externalId"]
    query = _concat_prop_user(
        user,
        db.session.query(
            *cols,
            f.count(BLSession.sessionId).label("sessions"),
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
    proposal: Optional[str],
    search: str,
    min_date: Optional[str],
    max_date: Optional[str],
) -> Paged[VisitOut]:
    query = db.session.query(BLSession)

    if proposal is not None:
        query = (
            query.select_from(Proposal)
            .filter(
                and_(
                    Proposal.proposalCode == proposal[:2],
                    Proposal.proposalNumber == proposal[2:],
                )
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
