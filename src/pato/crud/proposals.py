from sqlalchemy import func as f
from sqlalchemy import or_, select

from ..auth import User
from ..models.response import ProposalResponse
from ..models.table import BLSession, Proposal
from ..utils.auth import check_proposal
from ..utils.database import Paged, paginate


def get_proposals(
    limit: int, page: int, search: str, user: User
) -> Paged[ProposalResponse]:
    cols = [c for c in Proposal.__table__.columns if c.name != "externalId"]
    query = (
        select(
            *cols,
            f.count(BLSession.sessionId).label("sessions"),
        )
        .filter(
            or_(
                f.concat(Proposal.proposalCode, Proposal.proposalNumber).contains(
                    search
                ),
                Proposal.title.contains(search),
            )
        )
        .join(BLSession)
        .group_by(Proposal.proposalId)
        .order_by(BLSession.startDate.desc())
    )

    return paginate(check_proposal(query, user), limit, page, slow_count=True)
