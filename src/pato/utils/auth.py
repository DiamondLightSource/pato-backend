from sqlalchemy import Select, or_

from ..auth import User, is_admin
from ..models.table import BLSession, ProposalHasPerson, SessionHasPerson
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

    return query.join(SessionHasPerson, isouter=True).filter(
        or_(
            BLSession.beamLineName.in_(get_allowed_beamlines(user.permissions)),
            SessionHasPerson.personId == user.id,
        )
    )


def check_proposal(query: Select, user: User):
    if is_admin(user.permissions):
        return query

    return query.join(ProposalHasPerson, isouter=True).filter(
        or_(
            BLSession.beamLineName.in_(get_allowed_beamlines(user.permissions)),
            ProposalHasPerson.personId == user.id,
        )
    )
