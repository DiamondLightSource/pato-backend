from datetime import datetime
from enum import Enum
from typing import Optional

from pydantic import BaseModel, Field


class StateEnum(str, Enum):
    open = "Open"
    closed = "Closed"
    cancelled = "Cancelled"


class ProposalOut(BaseModel):
    proposalId: int = Field(..., lt=1e9, description="Proposal ID")
    personId: int
    title: str = Field(..., max_length=200)
    proposalCode: str = Field(..., max_length=45)
    proposalNumber: str = Field(..., max_length=45)
    bltimeStamp: datetime
    proposalType: Optional[str] = Field(..., max_length=2)
    state = StateEnum.open
    visits: int


class VisitOut(BaseModel):
    sessionId: int = Field(..., lt=1e9, description="Session ID")
    beamLineSetupId: Optional[int]
    proposalId: int = Field(..., lt=1e9, description="Proposal ID")
    beamCalendarId: Optional[int]
    projectCode: Optional[str] = Field(..., max_length=45)
    startDate: Optional[datetime]
    endDate: Optional[datetime]
    beamLineName: str = Field(..., max_length=45)
    scheduled: Optional[int] = Field(..., lt=10)
    nbShifts: Optional[int] = Field(..., lt=1e9)
    comments: Optional[str] = Field(..., max_length=2000)
    beamLineOperator: Optional[str]
    bltimeStamp = datetime
    visit_number: int = Field(..., lt=1e9)
    usedFlag: Optional[int] = Field(
        ...,
        lt=2,
        description="Indicates if session has Datacollections or XFE or EnergyScans attached",  # noqa: E501
    )
    sessionTitle: Optional[str] = Field(..., max_length=255)
    structureDeterminations: Optional[float]
    dewarTransport: Optional[float]
    databackupFrance: Optional[float] = Field(
        ..., description="Data backup and express delivery France"
    )
    databackupEurope: Optional[float] = Field(
        ..., description="Data backup and express delivery Europe"
    )
    expSessionPk: Optional[int] = Field(..., lt=1e10)
    operatorSiteNumber: Optional[str] = Field(
        ..., max_length=10, description="Matricule site"
    )
    lastUpdate: Optional[datetime] = Field(
        ...,
        description="Last update timestamp: by default the end of the session, the last collect",  # noqa: E501
    )
    protectedData: Optional[str] = Field(
        ..., max_length=1024, description="Indicates if the data is protected or not"
    )
    archived: int = Field(
        ...,
        lt=2,
        description="The data for the session is archived and no longer available on disk",  # noqa: E501
    )

    class Config:
        orm_mode = True


class DataCollectionSummaryOut(BaseModel):
    dataCollectionId: int = Field(..., lt=1e9, description="Data Collection ID")
    SESSIONID: int = Field(..., lt=1e9, description="Session ID")
    comments: Optional[str]
    startTime: Optional[datetime]
