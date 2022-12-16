from sqlalchemy.orm import Query

from ..auth import User
from ..models.table import BLSession, Proposal, ProposalHasPerson, SessionHasPerson
from .config import Config


def is_admin(perms: list[int]):
    return bool(set(Config.get()["auth"]["read_all_perms"]) & set(perms))


def is_em_staff(perms: list[int]):
    return bool(set(Config.get()["auth"]["read_em_perms"]) & set(perms))


def check_session(query: Query, user: User):
    if is_admin(user.permissions):
        return query

    if is_em_staff(user.permissions):
        return query.filter(BLSession.beamLineName.like("m__"))

    return query.filter(
        SessionHasPerson.personId == user.id,
        SessionHasPerson.sessionId == BLSession.sessionId,
    )


def check_proposal(query: Query, user: User):
    if is_admin(user.permissions):
        return query

    if is_em_staff(user.permissions):
        return query.filter(BLSession.beamLineName.like("m__"))

    return query.filter(
        ProposalHasPerson.personId == user.id,
        ProposalHasPerson.proposalId == Proposal.proposalId,
    )
