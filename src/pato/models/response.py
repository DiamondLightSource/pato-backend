from datetime import datetime
from enum import Enum
from typing import Generic, Optional, TypeVar

from lims_utils.models import Paged
from pydantic import BaseModel, ConfigDict, Field, field_validator

T = TypeVar("T")


class StateEnum(str, Enum):
    open = "Open"
    closed = "Closed"
    cancelled = "Cancelled"


class OrmBaseModel(BaseModel):
    model_config = ConfigDict(from_attributes=True, arbitrary_types_allowed=True)


class DataPoint(OrmBaseModel):
    x: str | float
    y: float

    @field_validator("x")
    @classmethod
    def coerce_into_float_by_default(cls, v: str):
        try:
            return float(v)
        except ValueError:
            return v


class ProposalResponse(OrmBaseModel):
    proposalId: int = Field(..., lt=1e9, description="Proposal ID")
    personId: int
    title: Optional[str] = Field(None, max_length=255)
    proposalCode: Optional[str] = Field(None, max_length=45)
    proposalNumber: Optional[str] = Field(None, max_length=45)
    bltimeStamp: datetime
    proposalType: Optional[str] = Field(None, max_length=2)
    state: StateEnum
    sessions: int


class SessionResponse(OrmBaseModel):
    sessionId: int = Field(..., lt=1e9, description="Session ID")
    beamLineSetupId: Optional[int] = None
    proposalId: int = Field(..., lt=1e9, description="Proposal ID")
    beamCalendarId: Optional[int] = None
    startDate: Optional[datetime] = None
    endDate: Optional[datetime] = None
    beamLineName: Optional[str] = Field(None, max_length=45)
    scheduled: Optional[int] = Field(None, lt=10)
    nbShifts: Optional[int] = Field(None, lt=1e9)
    comments: Optional[str] = Field(None, max_length=2000)
    beamLineOperator: Optional[str] = None
    bltimeStamp: datetime
    parentProposal: str
    visit_number: Optional[int] = Field(None, lt=1e9)
    usedFlag: Optional[int] = Field(
        None,
        lt=2,
        description="Indicates if session has Datacollections or XFE or EnergyScans attached",  # noqa: E501
    )
    lastUpdate: Optional[datetime] = Field(
        None,
        description="Last update timestamp: by default the end of the session, the last collect",  # noqa: E501
    )
    archived: int = Field(
        ...,
        lt=2,
        description="The data for the session is archived and no longer available on disk",  # noqa: E501
    )
    collectionGroups: Optional[int] = None
    dataCollectionGroupId: Optional[int] = None


class DataCollectionGroupSummaryResponse(OrmBaseModel):
    dataCollectionGroupId: int = Field(..., lt=1e9, description="Data Collection Group ID")
    sessionId: int = Field(..., lt=1e9, description="Session ID")
    experimentType: Optional[str] = None
    atlasId: Optional[int] = None
    experimentTypeId: Optional[int] = 37
    experimentTypeName: Optional[str] = "Single Particle"
    imageDirectory: Optional[str] = None
    comments: Optional[str] = None
    collections: int

    @field_validator("experimentTypeName")
    def replace_none(cls, v):
        return v or "Single Particle"


class ProcessingJobParameters(OrmBaseModel):
    items: dict[str, str]


class SessionAllowsReprocessing(OrmBaseModel):
    allowReprocessing: bool


class CTF(OrmBaseModel):
    ctfId: int
    boxSizeX: Optional[float] = Field(None, title="Box size in x")
    boxSizeY: Optional[float] = Field(None, title="Box size in y")
    minResolution: Optional[float] = Field(None, title="Minimum resolution for CTF")
    maxResolution: Optional[float] = None
    minDefocus: Optional[float] = None
    maxDefocus: Optional[float] = None
    defocusStepSize: Optional[float] = None
    astigmatism: Optional[float] = None
    astigmatismAngle: Optional[float] = None
    estimatedResolution: Optional[float] = None
    estimatedDefocus: Optional[float] = None
    amplitudeContrast: Optional[float] = None
    ccValue: Optional[float] = Field(None, title="Correlation value")
    fftTheoreticalFullPath: Optional[str] = Field(
        None, max_length=255, title="Full path to the jpg image of the simulated FFT"
    )
    comments: Optional[str] = Field(None, max_length=255)


class Movie(OrmBaseModel):
    movieId: int
    movieNumber: Optional[int] = None
    movieFullPath: Optional[str] = Field(None, max_length=255)
    createdTimeStamp: datetime
    positionX: Optional[float] = None
    positionY: Optional[float] = None
    nominalDefocus: Optional[float] = Field(None, title="Nominal defocus")
    angle: Optional[float] = None
    fluence: Optional[float] = Field(
        None,
        title="accumulated electron fluence from start to end of acquisition of movie",
    )
    numberOfFrames: Optional[int] = Field(
        None,
        title="number of frames per movie",
    )
    foilHoleId: Optional[int] = None
    gridSquareId: Optional[int] = None


class MotionCorrection(OrmBaseModel):
    motionCorrectionId: int
    dataCollectionId: Optional[int] = None
    autoProcProgramId: Optional[int] = None
    imageNumber: Optional[int] = Field(None, title="Movie number, sequential in time 1-n")
    firstFrame: Optional[int] = Field(None, title="First frame of movie used")
    lastFrame: Optional[int] = Field(None, title="Last frame of movie used")
    dosePerFrame: Optional[float] = Field(None, title="Dose per frame")
    doseWeight: Optional[float] = Field(None, title="Dose weight")
    totalMotion: Optional[float] = Field(None, title="Total motion")
    averageMotionPerFrame: Optional[float] = Field(None, title="Average motion per frame")
    driftPlotFullPath: Optional[str] = Field(None, max_length=255, title="Path to drift plot")
    micrographFullPath: Optional[str] = Field(None, max_length=255, title="Path to micrograph")
    micrographSnapshotFullPath: Optional[str] = Field(
        None, max_length=255, title="Path to micrograph"
    )
    patchesUsedX: Optional[int] = Field(None, title="Patches used in x")
    patchesUsedY: Optional[int] = Field(None, title="Patches used in y")
    fftFullPath: Optional[str] = Field(
        None,
        max_length=255,
        title="Path to raw micrograph FFT",
    )
    fftCorrectedFullPath: Optional[str] = Field(
        None,
        max_length=255,
        title="Path to drift corrected micrograph FFT",
    )
    comments: Optional[str] = Field(None, max_length=255)


class TiltImageAlignmentOut(OrmBaseModel):
    movieId: int
    defocusU: Optional[float] = None
    defocusV: Optional[float] = None
    psdFile: Optional[str] = Field(None, max_length=255)
    resolution: Optional[float] = None
    fitQuality: Optional[float] = None
    refinedMagnification: Optional[float] = None
    refinedTiltAngle: Optional[float] = None
    refinedTiltAxis: Optional[float] = None
    residualError: Optional[float] = None


class FullMovie(OrmBaseModel):
    CTF: CTF
    Movie: Movie
    MotionCorrection: MotionCorrection
    TiltImageAlignment: Optional[TiltImageAlignmentOut] = None


class FullMovieWithTilt(Paged[FullMovie]):
    alignedTotal: int


class CtfBase(OrmBaseModel):
    estimatedResolution: Optional[float] = None
    estimatedDefocus: Optional[float] = None
    astigmatism: Optional[float] = None


class CtfTiltAlign(CtfBase):
    refinedTiltAngle: Optional[float] = None


class CtfImageNumber(CtfBase):
    imageNumber: int


class CtfBaseSpa(CtfImageNumber):
    numberOfParticles: Optional[int] = None


class ItemList(BaseModel, Generic[T]):
    items: list[T]


class ProcessingJob(OrmBaseModel):
    processingJobId: int
    dataCollectionId: int
    displayName: Optional[str] = Field(None, max_length=80)
    comments: Optional[str] = Field(None, max_length=255)
    recordTimestamp: Optional[datetime] = None
    recipe: Optional[str] = Field(None, max_length=50)
    automatic: Optional[int] = None


class AutoProcProgramResponse(OrmBaseModel):
    autoProcProgramId: int
    processingCommandLine: Optional[str] = Field(max_length=255)
    processingPrograms: Optional[str] = Field(max_length=255)
    processingStatus: Optional[int] = None
    processingMessage: Optional[str] = Field(max_length=255)
    processingStartTime: Optional[datetime] = None
    processingEndTime: Optional[datetime] = None
    processingEnvironment: Optional[str] = Field(max_length=255)
    recordTimeStamp: Optional[datetime] = None


class ProcessingJobResponse(OrmBaseModel):
    AutoProcProgram: Optional[AutoProcProgramResponse] = None
    ProcessingJob: ProcessingJob
    status: str


class TomogramResponse(OrmBaseModel):
    dataCollectionId: int
    tomogramId: int
    volumeFile: Optional[str] = Field(None, max_length=255)
    stackFile: Optional[str] = Field(None, max_length=255)
    sizeX: Optional[int] = None
    sizeY: Optional[int] = None
    sizeZ: Optional[int] = None
    pixelLocationX: Optional[int] = None
    pixelLocationY: Optional[int] = None
    pixelSpacing: Optional[float] = None
    residualErrorMean: Optional[float] = None
    residualErrorSD: Optional[float] = None
    xAxisCorrection: Optional[float] = None
    tiltAngleOffset: Optional[float] = None
    zShift: Optional[float] = None
    refinedTiltAxis: Optional[float] = None


class TomogramFullResponse(ProcessingJobResponse):
    Tomogram: Optional[TomogramResponse] = None


class ParticlePicker(OrmBaseModel):
    particleDiameter: Optional[float] = None
    numberOfParticles: Optional[int] = None
    particlePickerId: Optional[int] = None
    summaryFullImagePath: Optional[str] = None
    imageNumber: int
    movieId: int
    createdTimeStamp: Optional[datetime] = None


class Classification(OrmBaseModel):
    particleClassificationGroupId: int
    particlePickerId: int
    programId: int
    type: str
    batchNumber: int
    numberOfParticlesPerBatch: int
    numberOfClassesPerBatch: int
    symmetry: str
    particleClassificationId: int
    classNumber: int
    classImageFullPath: Optional[str] = None
    particlesPerClass: Optional[int] = None
    rotationAccuracy: Optional[float] = None
    translationAccuracy: Optional[float] = None
    estimatedResolution: Optional[float] = None
    overallFourierCompleteness: Optional[float] = None
    classDistribution: Optional[float] = None
    selected: Optional[bool] = None
    bFactorFitIntercept: Optional[float] = None
    bFactorFitLinear: Optional[float] = None
    angularEfficiency: Optional[float] = None
    suggestedTilt: Optional[float] = None


class RelativeIceThickness(OrmBaseModel):
    minimum: float
    q1: float
    median: float
    q3: float
    maximum: float
    stddev: Optional[float] = None


class IceThicknessWithAverage(OrmBaseModel):
    current: RelativeIceThickness = Field(
        ...,
        description="Ice thickness data for current selected movie",
    )
    avg: Optional[RelativeIceThickness] = Field(
        ...,
        description="Average ice thickness data for movies belonging to autoproc. program",
    )


class ReprocessingResponse(BaseModel):
    processingJobId: int


class BFactorFitOut(BaseModel):
    numberOfParticles: float
    resolution: float


class GridSquare(BaseModel):
    gridSquareId: int
    x: int = Field(validation_alias="pixelLocationX")
    y: int = Field(validation_alias="pixelLocationY")
    height: int
    width: int
    angle: float
    image: Optional[str] = Field(validation_alias="gridSquareImage", default=None)


class Atlas(BaseModel):
    atlasId: int
    pixelSize: float
    cassetteSlot: Optional[int] = None
    dataCollectionGroupId: int


class FoilHole(BaseModel):
    diameter: int
    foilHoleId: int
    x: int = Field(validation_alias="pixelLocationX")
    y: int = Field(validation_alias="pixelLocationY")
    movieCount: Optional[int] = 0
    particleCount: Optional[float] = None
    resolution: Optional[float] = None
    astigmatism: Optional[float] = None
