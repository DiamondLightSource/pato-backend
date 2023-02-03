from datetime import datetime
from typing import Optional

from sqlalchemy import and_
from sqlalchemy import func as f
from sqlalchemy import or_

from ..auth import User
from ..models.response import VisitOut
from ..models.table import BLSession, DataCollectionGroup, Proposal
from ..utils.auth import check_session
from ..utils.database import Paged, db, fast_count, paginate, unravel


def get_sessions(
    limit: int,
    page: int,
    user: User,
    proposal: Optional[str],
    search: str,
    minEndDate: Optional[datetime],
    maxEndDate: Optional[datetime],
    minStartDate: Optional[datetime],
    maxStartDate: Optional[datetime],
) -> Paged[VisitOut]:
    query = db.session.query(
        *unravel(BLSession),
        f.concat(Proposal.proposalCode, Proposal.proposalNumber).label(
            "parentProposal"
        ),
        f.count(DataCollectionGroup.dataCollectionGroupId).label("collectionGroups"),
    )

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

    query = check_session(
        query.filter(
            or_(
                BLSession.beamLineName.contains(search),
                BLSession.visit_number.contains(search),
                search == "",
            )
        ),
        user,
    )

    total = fast_count(query)

    query = query.join(DataCollectionGroup, isouter=True).group_by(
        BLSession.visit_number
    )

    return paginate(query, limit, page, precounted_total=total)
