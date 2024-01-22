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

    return query.join(
        SessionHasPerson,
        and_(
            SessionHasPerson.sessionId == BLSession.sessionId,
            SessionHasPerson.personId == user.id,
        ),
        isouter=True,
    ).filter(
        or_(
            SessionHasPerson.personId == user.id,
            BLSession.beamLineName.in_(get_allowed_beamlines(user.permissions)),
        ),
    )


def check_proposal(query: Select, user: User):
    if is_admin(user.permissions):
        return query

    return query.join(
        ProposalHasPerson,
        and_(
            ProposalHasPerson.personId == user.id,
            ProposalHasPerson.proposalId == Proposal.proposalId,
        ),
        isouter=True,
    ).filter(
        or_(
            ProposalHasPerson.personId == user.id,
            BLSession.beamLineName.in_(get_allowed_beamlines(user.permissions)),
        ),
    )
