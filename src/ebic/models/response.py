from datetime import datetime
from enum import Enum
from typing import Optional

from pydantic import BaseModel, Field

from ..utils.database import Paged


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
    sessions: int


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
    tomograms: int


class DataCollectionGroupSummaryOut(BaseModel):
    dataCollectionGroupId: int = Field(
        ..., lt=1e9, description="Data Collection Group ID"
    )
    sessionId: int = Field(..., lt=1e9, description="Session ID")
    comments: Optional[str]
    collections: int


class CTF(BaseModel):
    ctfId: int
    boxSizeX: Optional[float] = Field(..., title="Box size in x", unit="pixels")
    boxSizeY: Optional[float] = Field(..., title="Box size in y", unit="pixels")
    minResolution: Optional[float] = Field(
        ..., title="Minimum resolution for CTF", unit="A"
    )
    maxResolution: Optional[float] = Field(..., unit="A")
    minDefocus: Optional[float] = Field(..., unit="A")
    maxDefocus: Optional[float] = Field(..., unit="A")
    defocusStepSize: Optional[float] = Field(..., unit="A")
    astigmatism: Optional[float] = Field(..., unit="A")
    astigmatismAngle: Optional[float] = Field(..., unit="deg?")
    estimatedResolution: Optional[float] = Field(..., unit="A")
    estimatedDefocus: Optional[float] = Field(..., unit="A")
    amplitudeContrast: Optional[float] = Field(..., unit="%?")
    ccValue: Optional[float] = Field(..., title="Correlation value")
    fftTheoreticalFullPath: Optional[str] = Field(
        ..., max_length=255, title="Full path to the jpg image of the simulated FFT"
    )
    comments: Optional[str] = Field(..., max_length=255)

    class Config:
        orm_mode = True


class Movie(BaseModel):
    movieId: int
    movieNumber: Optional[int]
    movieFullPath: Optional[str] = Field(..., max_length=255)
    createdTimeStamp: datetime
    positionX: Optional[float]
    positionY: Optional[float]
    nominalDefocus: Optional[float] = Field(..., title="Nominal defocus", unit="A")
    angle: Optional[float] = Field(
        ..., unit="degrees relative to perpendicular to beam"
    )
    fluence: Optional[float] = Field(
        ...,
        title="accumulated electron fluence from start to end of acquisition of movie",
    )
    numberOfFrames: Optional[int] = Field(
        ...,
        title="number of frames per movie",
    )

    class Config:
        orm_mode = True


class MotionCorrection(BaseModel):
    motionCorrectionId: int
    dataCollectionId: int
    autoProcProgramId: Optional[int]
    imageNumber: Optional[int] = Field(
        ..., title="Movie number, sequential in time 1-n"
    )
    firstFrame: Optional[int] = Field(..., title="First frame of movie used")
    lastFrame: Optional[int] = Field(..., title="Last frame of movie used")
    dosePerFrame: Optional[float] = Field(..., title="Dose per frame", unit="e-/A^2")
    doseWeight: Optional[float] = Field(..., title="Dose weight")
    totalMotion: Optional[float] = Field(..., title="Total motion", unit="A")
    averageMotionPerFrame: Optional[float] = Field(
        ..., title="Average motion per frame", unit="A"
    )
    driftPlotFullPath: Optional[str] = Field(
        ..., max_length=255, title="Path to drift plot"
    )
    micrographFullPath: Optional[str] = Field(
        ..., max_length=255, title="Path to micrograph"
    )
    micrographSnapshotFullPath: Optional[str] = Field(
        ..., max_length=255, title="Path to micrograph"
    )
    patchesUsedX: Optional[int] = Field(..., title="Patches used in x")
    patchesUsedY: Optional[int] = Field(..., title="Patches used in y")
    fftFullPath: Optional[str] = Field(
        ...,
        max_length=255,
        title="Path to raw micrograph FFT",
    )
    fftCorrectedFullPath: Optional[str] = Field(
        ...,
        max_length=255,
        title="Path to drift corrected micrograph FFT",
    )
    comments: Optional[str] = Field(..., max_length=255)

    class Config:
        orm_mode = True


class TiltImageAlignment(BaseModel):
    movieId: int
    defocusU: Optional[float]
    defocusV: Optional[float]
    psdFile: Optional[str] = Field(..., max_length=255)
    resolution: Optional[float]
    fitQuality: Optional[float]
    refinedMagnification: Optional[float]
    refinedTiltAngle: Optional[float]
    refinedTiltAxis: Optional[float]
    residualError: Optional[float]

    class Config:
        orm_mode = True


class FullMovie(BaseModel):
    CTF: CTF
    Movie: Movie
    MotionCorrection: MotionCorrection
    TiltImageAlignment: Optional[TiltImageAlignment]


class FullMovieWithTilt(Paged[FullMovie]):
    rawTotal: int

    class Config:
        orm_mode = True


class CtfTiltAlign(BaseModel):
    estimatedResolution: Optional[float]
    estimatedDefocus: Optional[float]
    astigmatism: Optional[float]
    refinedTiltAngle: Optional[float]

    class Config:
        orm_mode = True


class CtfOut(BaseModel):
    items: list[CtfTiltAlign]


class GenericPlot(BaseModel):
    items: list[DataPoint]


class Tomogram(BaseModel):
    tomogramId: int
    dataCollectionId: int
    autoProcProgramId: Optional[int]
    volumeFile: Optional[str] = Field(..., max_length=255)
    stackFile: Optional[str] = Field(..., max_length=255)
    sizeX: Optional[int]
    sizeY: Optional[int]
    sizeZ: Optional[int]
    pixelSpacing: Optional[float]
    residualErrorMean: Optional[float]
    residualErrorSD: Optional[float]
    xAxisCorrection: Optional[float]
    tiltAngleOffset: Optional[float]
    zShift: Optional[float]

    class Config:
        orm_mode = True
