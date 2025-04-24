from lims_utils.auth import GenericUser
from lims_utils.tables import BLSession, Proposal, ProposalHasPerson, SessionHasPerson
from sqlalchemy import Select, and_, or_

from ..auth import is_admin
from .config import Config


def get_allowed_beamlines(perms: list[int]) -> set[str]:
    allowed_beamlines: set[str] = set()

    for perm in perms:
        if str(perm) in Config.auth.beamline_mapping:
            allowed_beamlines.update(Config.auth.beamline_mapping[str(perm)])

    return allowed_beamlines

def _get_staff_perms(user: GenericUser):
    """Get the appropriate set of beamline-related permissions based on an user's user groups

    Args:
        user: User to check permissions for

    Returns:
        Additional SQL conditions based on user permissions, or None if user has no extra permissions"""
    allowed_beamlines = get_allowed_beamlines(user.permissions)
    user_is_admin = is_admin(user.permissions)

    if allowed_beamlines or user_is_admin:
        if Config.facility.users_only_on_industrial:
            # We only want to restrict industrial visits to listed users
            return and_(
                Proposal.proposalCode.not_in(["ic", "il", "in", "sw"]),
                or_(
                    BLSession.beamLineName.in_(allowed_beamlines),
                    user_is_admin,
                ),
            )

        return BLSession.beamLineName.in_(allowed_beamlines)

def check_session(query: Select, user: GenericUser, join_proposal: bool = False):
    """Include filters in provided query to ensure that only sessions the user has permission to view
    are returned.

    Args:
        query: Original query
        user: User to check against
        join_proposal: Join proposal when building query

    Returns
        Modified query"""
    if not Config.facility.users_only_on_industrial and is_admin(user.permissions):
        return query

    or_expressions = [SessionHasPerson.personId == user.id]

    staff_perms = _get_staff_perms(user)
    if staff_perms is not None:
        if Config.facility.users_only_on_industrial and join_proposal:
            query = query.join(Proposal, BLSession.proposalId == Proposal.proposalId)
        or_expressions.append(staff_perms)

    return (
        query.distinct()
        .join(
            SessionHasPerson,
            SessionHasPerson.sessionId == BLSession.sessionId,
            isouter=(staff_perms is not None),
        )
        .filter(
            or_(*or_expressions),
        )
    )


def check_proposal(query: Select, user: GenericUser):
    """Include filters in provided query to ensure that only proposals the user has permission to view
    are returned.

    Args:
        query: Original query
        user: User to check against

    Returns
        Modified query"""
    if not Config.facility.users_only_on_industrial and is_admin(user.permissions):
        return query

    or_expressions = [ProposalHasPerson.personId == user.id]

    staff_perms = _get_staff_perms(user)
    if staff_perms is not None:
        or_expressions.append(staff_perms)

    return (
        query.distinct()
        .join(
            ProposalHasPerson,
            ProposalHasPerson.proposalId == Proposal.proposalId,
            isouter=(staff_perms is not None),
        )
        .filter(
            or_(*or_expressions),
        )
    )
