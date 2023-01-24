from typing import Optional

from sqlalchemy import and_
from sqlalchemy import func as f
from sqlalchemy import or_

from ..auth import User
from ..models.response import VisitOut
from ..models.table import BLSession, DataCollectionGroup, Proposal
from ..utils.auth import check_session
from ..utils.database import Paged, db, paginate, unravel


def get_sessions(
    limit: int,
    page: int,
    user: User,
    proposal: Optional[str],
    search: str,
    min_date: Optional[str],
    max_date: Optional[str],
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
        )
    else:
        query = query.join(Proposal)

    if min_date is not None and max_date is not None:
        query = query.filter(and_(BLSession.startDate.between(min_date, max_date)))

    query = (
        query.filter(
            or_(
                BLSession.beamLineName.contains(search),
                BLSession.visit_number.contains(search),
                search == "",
            )
        )
        .join(DataCollectionGroup, isouter=True)
        .group_by(BLSession.visit_number)
        .order_by(BLSession.visit_number)
    )

    return paginate(check_session(query, user), limit, page, slow_count=False)
