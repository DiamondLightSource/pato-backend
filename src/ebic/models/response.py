from datetime import datetime
from enum import Enum
from typing import Optional

from pydantic import BaseModel, Field


class StateEnum(str, Enum):
    open = "Open"
    closed = "Closed"
    cancelled = "Cancelled"


class ProposalOut(BaseModel):
    proposalId: int = Field(..., description="Proposal ID")
    personId: int
    title: str = Field(..., max_length=200)
    proposalCode: str = Field(..., max_length=45)
    proposalNumber: str = Field(..., max_length=45)
    bltimeStamp: Optional[datetime]
    proposalType: Optional[str] = Field(..., max_length=2)
    state = StateEnum.open
