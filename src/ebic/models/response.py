from datetime import datetime
from enum import Enum
from typing import Optional

from pydantic import BaseModel, Field


class StateEnum(str, Enum):
    open = "Open"
    closed = "Closed"
    cancelled = "Cancelled"


class DataPoint(BaseModel):
    x: float
    y: float


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
    pixelSizeOnImage: Optional[float] = Field(
        ...,
        comment="Pixel size on image, calculated from magnification",
    )
    voltage: Optional[float] = Field(..., comment="Unit: kV")
    imageSizeX: Optional[int] = Field(
        ...,
        comment="Image size in x, in case crop has been used.",
    )
    imageSizeY: Optional[int] = Field(
        ..., comment="Image size in y, in case crop has been used."
    )


class DataCollectionGroupSummaryOut(BaseModel):
    dataCollectionGroupId: int = Field(
        ..., lt=1e9, description="Data Collection Group ID"
    )
    sessionId: int = Field(..., lt=1e9, description="Session ID")
    comments: Optional[str]
    collections: int


class MotionOut(BaseModel):
    motionCorrectionId: int = Field(..., lt=1e11)
    dataCollectionId: int
    autoProcProgramId: Optional[int]
    imageNumber: Optional[int] = Field(
        ..., comment="Movie number, sequential in time 1-n"
    )
    firstFrame: Optional[int] = Field(..., comment="First frame of movie used")
    lastFrame: Optional[int] = Field(..., comment="Last frame of movie used")
    dosePerFrame: Optional[float] = Field(..., comment="Dose per frame")
    totalMotion: Optional[float] = Field(..., comment="Total motion")
    averageMotionPerFrame: Optional[float]
    driftPlotFullPath: Optional[str] = Field(..., max_length=255)
    micrographFullPath: Optional[str] = Field(..., max_length=255)
    micrographSnapshotFullPath: Optional[str] = Field(..., max_length=255)
    patchesUsedX: Optional[int]
    patchesUsedY: Optional[int]
    fftFullPath: Optional[str] = Field(..., max_length=255)
    fftCorrectedFullPath: Optional[str] = Field(..., max_length=255)
    comments_MotionCorrection: Optional[str] = Field(..., max_length=255)
    movieId: Optional[int]
    ctfId: Optional[int]
    boxSizeX: Optional[float]
    boxSizeY: Optional[float]
    minResolution: Optional[float]
    maxResolution: Optional[float]
    minDefocus: Optional[float]
    maxDefocus: Optional[float]
    defocusStepSize: Optional[float]
    astigmatism: Optional[float]
    astigmatismAngle: Optional[float]
    estimatedResolution: Optional[float]
    estimatedDefocus: Optional[float]
    amplitudeContrast: Optional[float]
    ccValue: Optional[float]
    fftTheoreticalFullPath: Optional[str] = Field(..., max_length=255)
    comments_CTF: Optional[str] = Field(..., max_length=255)
    movieNumber: Optional[int]
    movieFullPath: Optional[str] = Field(..., max_length=255)
    createdTimeStamp: datetime
    positionX: Optional[float]
    positionY: Optional[float]
    nominalDefocus: Optional[float]
    angle: Optional[float]
    fluence: Optional[float] = Field(
        ...,
        comment="""accumulated electron fluence from start to end of acquisition of this
        movie (commonly, but incorrectly, referred to as ‘dose’)""",
    )
    numberOfFrames: Optional[int]
    drift: list[DataPoint]
    total: int


class TiltAlignmentOut(MotionOut):
    tomogramId: int
    defocusU: Optional[float]
    defocusV: Optional[float]
    psdFile: Optional[str] = Field(..., max_length=255)
    resolution: Optional[float]
    fitQuality: Optional[float]
    refinedMagnification: Optional[float]
    refinedTiltAngle: Optional[float]
    refinedTiltAxis: Optional[float]
    residualError: Optional[float]
    rawTotal: int
