from typing import Optional

from sqlalchemy import and_

from ..auth import User
from ..models.response import VisitOut
from ..models.table import BLSession, Proposal
from ..utils.auth import check_session
from ..utils.database import Paged, db, paginate


def get_sessions(
    limit: int,
    page: int,
    user: User,
    proposal: Optional[str],
    search: str,
    min_date: Optional[str],
    max_date: Optional[str],
) -> Paged[VisitOut]:
    query = db.session.query(BLSession)

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

    if min_date is not None and max_date is not None:
        query = query.filter(and_(BLSession.startDate.between(min_date, max_date)))

    query = query.filter(BLSession.visit_number.contains(search)).order_by(
        BLSession.visit_number
    )

    return paginate(check_session(query, user), limit, page)
