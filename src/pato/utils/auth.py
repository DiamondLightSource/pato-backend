from lims_utils.tables import BLSession, Proposal, ProposalHasPerson, SessionHasPerson
from sqlalchemy import Select, and_, or_

from ..auth import User, is_admin
from .config import Config


def get_allowed_beamlines(perms: list[int]) -> set[str]:
    allowed_beamlines: set[str] = set()

    for perm in perms:
        if str(perm) in Config.auth.beamline_mapping:
            allowed_beamlines.update(Config.auth.beamline_mapping[str(perm)])

    return allowed_beamlines


def check_session(query: Select, user: User):
    if is_admin(user.permissions):
        return query

    allowed_beamlines = get_allowed_beamlines(user.permissions)
    or_expressions = [SessionHasPerson.personId == user.id]
    join_conditions = [SessionHasPerson.sessionId == BLSession.sessionId]

    if allowed_beamlines:
        or_expressions.append(BLSession.beamLineName.in_(allowed_beamlines))
        join_conditions.append(SessionHasPerson.personId == user.id)

    return query.join(
        SessionHasPerson,
        and_(*join_conditions),
        isouter=(len(allowed_beamlines) > 0),
    ).filter(or_(*or_expressions))


def check_proposal(query: Select, user: User):
    if is_admin(user.permissions):
        return query

    allowed_beamlines = get_allowed_beamlines(user.permissions)
    or_expressions = [ProposalHasPerson.personId == user.id]
    join_conditions = [ProposalHasPerson.proposalId == Proposal.proposalId]

    if allowed_beamlines:
        or_expressions.append(BLSession.beamLineName.in_(allowed_beamlines))
        join_conditions.append(ProposalHasPerson.personId == user.id)

    return query.join(
        ProposalHasPerson,
        and_(*join_conditions),
        isouter=(len(allowed_beamlines) > 0),
    ).filter(
        or_(*or_expressions),
    )
