from sqlalchemy import or_
from sqlalchemy.orm import Query

from ..auth import User
from ..models.table import BLSession, ProposalHasPerson, SessionHasPerson
from .config import Config


def get_allowed_beamlines(perms: list[int]) -> set[str]:
    allowed_beamlines: set[str] = set()

    for perm in perms:
        if str(perm) in Config.auth.beamline_mapping:
            allowed_beamlines.update(Config.auth.beamline_mapping[str(perm)])

    return allowed_beamlines


def is_admin(perms: list[int]):
    return bool(set(Config.auth.read_all_perms) & set(perms))


def is_em_staff(perms: list[int]):
    return bool(set(Config.auth.read_em_perms) & set(perms))


def check_session(query: Query, user: User):
    if is_admin(user.permissions):
        return query

    if is_em_staff(user.permissions):
        return query.filter(BLSession.beamLineName.like("m__"))

    return query.join(SessionHasPerson, isouter=True).filter(
        or_(
            BLSession.beamLineName.in_(get_allowed_beamlines(user.permissions)),
            SessionHasPerson.personId == user.id,
        )
    )


def check_proposal(query: Query, user: User):
    if is_admin(user.permissions):
        return query

    if is_em_staff(user.permissions):
        return query.filter(BLSession.beamLineName.like("m__"))

    return query.join(ProposalHasPerson, isouter=True).filter(
        or_(
            BLSession.beamLineName.in_(get_allowed_beamlines(user.permissions)),
            ProposalHasPerson.personId == user.id,
        )
    )
