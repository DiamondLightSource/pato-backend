from sqlalchemy import func as f

from ..auth import User
from ..models.response import ProposalOut
from ..models.table import BLSession, Proposal
from ..utils.auth import check_proposal
from ..utils.database import Paged, db, paginate


def get_proposals(limit: int, page: int, search: str, user: User) -> Paged[ProposalOut]:
    cols = [c for c in Proposal.__table__.columns if c.name != "externalId"]
    query = (
        db.session.query(
            *cols,
            f.count(BLSession.sessionId).label("sessions"),
        )
        .filter(
            f.concat(Proposal.proposalCode, Proposal.proposalNumber).contains(search)
        )
        .join(BLSession)
        .group_by(Proposal.proposalId)
    )

    return paginate(check_proposal(query, user), limit, page, slow_count=True)
