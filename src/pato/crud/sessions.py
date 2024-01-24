from datetime import datetime
from typing import Optional

from fastapi import HTTPException, status
from lims_utils.models import Paged
from lims_utils.tables import BLSession, DataCollectionGroup, Proposal
from sqlalchemy import Label, and_, or_, select
from sqlalchemy import func as f

from ..auth import User
from ..models.response import SessionResponse
from ..utils.auth import check_session
from ..utils.database import db, fast_count, paginate, unravel
from ..utils.generic import ProposalReference, parse_proposal


def get_sessions(
    limit: int,
    page: int,
    user: User,
    proposal: Optional[str],
    search: Optional[str],
    minEndDate: Optional[datetime],
    maxEndDate: Optional[datetime],
    minStartDate: Optional[datetime],
    maxStartDate: Optional[datetime],
    countCollections: bool,
) -> Paged[SessionResponse]:
    fields: list[Label[str] | Label[int]] = [
        f.concat(Proposal.proposalCode, Proposal.proposalNumber).label("parentProposal")
    ]

    if countCollections:
        fields.append(
            f.count(DataCollectionGroup.dataCollectionGroupId).label("collectionGroups")
        )

    query = select(*unravel(BLSession), *fields)

    if proposal is not None:
        proposal_reference = parse_proposal(proposal)
        query = (
            query.select_from(Proposal)
            .filter(
                and_(
                    Proposal.proposalCode == proposal_reference.code,
                    Proposal.proposalNumber == proposal_reference.number,
                )
            )
            .join(BLSession)
            .order_by(BLSession.visit_number)
        )
    else:
        query = query.join(Proposal).order_by(BLSession.endDate.desc())

    if minEndDate is not None:
        query = query.filter(BLSession.endDate >= minEndDate)

    if maxEndDate is not None:
        query = query.filter(BLSession.endDate <= maxEndDate)

    if minStartDate is not None:
        query = query.filter(BLSession.startDate >= minStartDate)

    if maxStartDate is not None:
        query = query.filter(BLSession.startDate <= maxStartDate)

    if search is not None:
        query = query.filter(
            or_(
                BLSession.beamLineName.contains(search),
                BLSession.visit_number.contains(search),
            )
        )

    query = check_session(query, user)

    total = fast_count(query)

    if countCollections:
        query = query.join(DataCollectionGroup, isouter=True).group_by(
            BLSession.visit_number, BLSession.proposalId
        )

    return paginate(query, limit, page, precounted_total=total)


def get_session(proposalReference: ProposalReference):
    query = (
        select(
            *unravel(BLSession),
            f.concat(Proposal.proposalCode, Proposal.proposalNumber).label(
                "parentProposal"
            ),
        )
        .select_from(Proposal)
        .filter(
            Proposal.proposalCode == proposalReference.code,
            Proposal.proposalNumber == proposalReference.number,
        )
        .join(BLSession)
        .filter(BLSession.visit_number == proposalReference.visit_number)
    )

    session = db.session.execute(query).first()

    if session is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Session does not exist"
        )

    return session
