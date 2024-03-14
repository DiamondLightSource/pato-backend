from lims_utils.auth import GenericUser
from lims_utils.tables import BLSession, Proposal, ProposalHasPerson, SessionHasPerson
from sqlalchemy import Select, or_

from ..auth import is_admin
from .config import Config


def get_allowed_beamlines(perms: list[int]) -> set[str]:
    allowed_beamlines: set[str] = set()

    for perm in perms:
        if str(perm) in Config.auth.beamline_mapping:
            allowed_beamlines.update(Config.auth.beamline_mapping[str(perm)])

    return allowed_beamlines


def check_session(query: Select, user: GenericUser):
    if is_admin(user.permissions):
        return query

    allowed_beamlines = get_allowed_beamlines(user.permissions)
    or_expressions = [SessionHasPerson.personId == user.id]

    if allowed_beamlines:
        or_expressions.append(BLSession.beamLineName.in_(allowed_beamlines))

    return (
        query.distinct()
        .join(
            SessionHasPerson,
            SessionHasPerson.sessionId == BLSession.sessionId,
            isouter=(len(allowed_beamlines) > 0),
        )
        .filter(
            or_(*or_expressions),
        )
    )


def check_proposal(query: Select, user: GenericUser):
    if is_admin(user.permissions):
        return query

    allowed_beamlines = get_allowed_beamlines(user.permissions)
    or_expressions = [ProposalHasPerson.personId == user.id]

    if allowed_beamlines:
        or_expressions.append(BLSession.beamLineName.in_(allowed_beamlines))

    return (
        query.distinct()
        .join(
            ProposalHasPerson,
            ProposalHasPerson.proposalId == Proposal.proposalId,
            isouter=(len(allowed_beamlines) > 0),
        )
        .filter(
            or_(*or_expressions),
        )
    )
