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


class RotationAxisEnum(str, Enum):
    omega = "Omega"
    kappa = "Kappa"
    phi = "Phi"


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
    title: Optional[str] = Field(..., max_length=255)
    proposalCode: Optional[str] = Field(..., max_length=45)
    proposalNumber: Optional[str] = Field(..., max_length=45)
    bltimeStamp: datetime
    proposalType: Optional[str] = Field(..., max_length=2)
    state: StateEnum
    sessions: int


class SessionResponse(OrmBaseModel):
    sessionId: int = Field(..., lt=1e9, description="Session ID")
    beamLineSetupId: Optional[int]
    proposalId: int = Field(..., lt=1e9, description="Proposal ID")
    beamCalendarId: Optional[int]
    startDate: Optional[datetime]
    endDate: Optional[datetime]
    beamLineName: Optional[str] = Field(..., max_length=45)
    scheduled: Optional[int] = Field(..., lt=10)
    nbShifts: Optional[int] = Field(..., lt=1e9)
    comments: Optional[str] = Field(..., max_length=2000)
    beamLineOperator: Optional[str]
    bltimeStamp: datetime
    parentProposal: str
    visit_number: Optional[int] = Field(..., lt=1e9)
    usedFlag: Optional[int] = Field(
        ...,
        lt=2,
        description="Indicates if session has Datacollections or XFE or EnergyScans attached",  # noqa: E501
    )
    lastUpdate: Optional[datetime] = Field(
        ...,
        description="Last update timestamp: by default the end of the session, the last collect",  # noqa: E501
    )
    archived: int = Field(
        ...,
        lt=2,
        description="The data for the session is archived and no longer available on disk",  # noqa: E501
    )
    collectionGroups: Optional[int] = None
    dataCollectionGroupId: Optional[int] = None


class BaseDataCollectionOut(OrmBaseModel):
    dataCollectionId: int = Field(..., lt=1e9, description="Data Collection ID")
    dataCollectionGroupId: int
    index: Optional[int] = None
    startTime: Optional[datetime] = Field(
        ..., description="Start time of the dataCollection"
    )
    endTime: Optional[datetime] = Field(
        ..., description="End time of the dataCollection"
    )
    experimenttype: Optional[str] = Field(..., max_length=24)
    fileTemplate: Optional[str] = Field(..., max_length=255)
    imageSuffix: Optional[str] = Field(..., max_length=24)
    imageDirectory: Optional[str] = Field(
        ...,
        max_length=255,
        description="The directory where files reside - should end with a slash",
    )
    imagePrefix: Optional[str] = Field(..., max_length=45)


class DataCollectionSummary(BaseDataCollectionOut):
    comments: Optional[str]
    pixelSizeOnImage: Optional[float] = Field(
        ...,
        description="Pixel size on image, calculated from magnification",
    )
    voltage: Optional[float] = None
    imageSizeX: Optional[int] = Field(
        ...,
        description="Image size in x, in case crop has been used.",
    )
    imageSizeY: Optional[int] = Field(
        ..., description="Image size in y, in case crop has been used."
    )
    runStatus: Optional[str] = Field(..., max_length=255)
    axisStart: Optional[float]
    axisEnd: Optional[float]
    axisRange: Optional[float]
    overlap: Optional[float]
    numberOfImages: Optional[int]
    startImageNumber: Optional[int]
    numberOfPasses: Optional[int]
    exposureTime: Optional[float]
    imageContainerSubPath: Optional[str] = Field(
        ...,
        max_length=255,
        description="""Internal path of a HDF5 file pointing to the data
        for this data collection""",
    )
    wavelength: Optional[float]
    resolution: Optional[float]
    detectorDistance: Optional[float]
    xBeam: Optional[float]
    yBeam: Optional[float]
    printableForReport: Optional[int]
    slitGapVertical: Optional[float]
    slitGapHorizontal: Optional[float]
    transmission: Optional[float]
    synchrotronMode: Optional[str] = Field(..., max_length=20)
    xtalSnapshotFullPath1: Optional[str] = Field(..., max_length=255)
    xtalSnapshotFullPath2: Optional[str] = Field(..., max_length=255)
    xtalSnapshotFullPath3: Optional[str] = Field(..., max_length=255)
    xtalSnapshotFullPath4: Optional[str] = Field(..., max_length=255)
    rotationAxis: Optional[RotationAxisEnum]
    phiStart: Optional[float]
    kappaStart: Optional[float]
    omegaStart: Optional[float]
    chiStart: Optional[float]
    resolutionAtCorner: Optional[float]
    detector2Theta: Optional[float]
    undulatorGap1: Optional[float]
    undulatorGap2: Optional[float]
    undulatorGap3: Optional[float]
    beamSizeAtSampleX: Optional[float]
    beamSizeAtSampleY: Optional[float]
    centeringMethod: Optional[str] = Field(..., max_length=255)
    averageTemperature: Optional[float]
    actualCenteringPosition: Optional[str] = Field(..., max_length=255)
    beamShape: Optional[str] = Field(..., max_length=24)
    detectorId: Optional[int]
    screeningOrigId: Optional[int]
    startPositionId: Optional[int]
    endPositionId: Optional[int]
    flux: Optional[float]
    strategySubWedgeOrigId: Optional[int]
    blSubSampleId: Optional[int]
    flux_end: Optional[float]
    bestWilsonPlotPath: Optional[str] = Field(..., max_length=255)
    processedDataFile: Optional[str] = Field(..., max_length=255)
    datFullPath: Optional[str] = Field(..., max_length=255)
    magnification: Optional[float]
    totalAbsorbedDose: Optional[float]
    binning: Optional[int]
    particleDiameter: Optional[float]
    boxSize_CTF: Optional[float]
    minResolution: Optional[float]
    minDefocus: Optional[float]
    maxDefocus: Optional[float]
    defocusStepSize: Optional[float]
    amountAstigmatism: Optional[float]
    extractSize: Optional[float]
    bgRadius: Optional[float]
    objAperture: Optional[float]
    c1aperture: Optional[float]
    c2aperture: Optional[float]
    c3aperture: Optional[float]
    c1lens: Optional[float]
    c2lens: Optional[float]
    c3lens: Optional[float]
    totalExposedDose: Optional[float]
    nominalMagnification: Optional[float]
    nominalDefocus: Optional[float]
    phasePlate: Optional[str]
    dataCollectionPlanId: Optional[int]
    tomograms: int
    globalAlignmentQuality: Optional[float] = None

    @field_validator("phasePlate", mode="before")
    def to_bool_str(cls, v):
        phase_plate_used = v is not None and v != "0" and v != 0
        return "Yes" if phase_plate_used else "No"

    @field_validator("pixelSizeOnImage")
    def to_angstrom(cls, v):
        return v if v is None else v * 10


class DataCollectionGroupSummaryResponse(OrmBaseModel):
    dataCollectionGroupId: int = Field(
        ..., lt=1e9, description="Data Collection Group ID"
    )
    sessionId: int = Field(..., lt=1e9, description="Session ID")
    experimentType: Optional[str]
    experimentTypeId: Optional[int] = 37
    experimentTypeName: Optional[str] = "Single Particle"
    imageDirectory: Optional[str]
    comments: Optional[str]
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
    boxSizeX: Optional[float] = Field(..., title="Box size in x")
    boxSizeY: Optional[float] = Field(..., title="Box size in y")
    minResolution: Optional[float] = Field(..., title="Minimum resolution for CTF")
    maxResolution: Optional[float] = None
    minDefocus: Optional[float] = None
    maxDefocus: Optional[float] = None
    defocusStepSize: Optional[float] = None
    astigmatism: Optional[float] = None
    astigmatismAngle: Optional[float] = None
    estimatedResolution: Optional[float] = None
    estimatedDefocus: Optional[float] = None
    amplitudeContrast: Optional[float] = None
    ccValue: Optional[float] = Field(..., title="Correlation value")
    fftTheoreticalFullPath: Optional[str] = Field(
        ..., max_length=255, title="Full path to the jpg image of the simulated FFT"
    )
    comments: Optional[str] = Field(..., max_length=255)


class Movie(OrmBaseModel):
    movieId: int
    movieNumber: Optional[int]
    movieFullPath: Optional[str] = Field(..., max_length=255)
    createdTimeStamp: datetime
    positionX: Optional[float]
    positionY: Optional[float]
    nominalDefocus: Optional[float] = Field(..., title="Nominal defocus")
    angle: Optional[float] = None
    fluence: Optional[float] = Field(
        ...,
        title="accumulated electron fluence from start to end of acquisition of movie",
    )
    numberOfFrames: Optional[int] = Field(
        ...,
        title="number of frames per movie",
    )


class MotionCorrection(OrmBaseModel):
    motionCorrectionId: int
    dataCollectionId: Optional[int]
    autoProcProgramId: Optional[int]
    imageNumber: Optional[int] = Field(
        ..., title="Movie number, sequential in time 1-n"
    )
    firstFrame: Optional[int] = Field(..., title="First frame of movie used")
    lastFrame: Optional[int] = Field(..., title="Last frame of movie used")
    dosePerFrame: Optional[float] = Field(..., title="Dose per frame")
    doseWeight: Optional[float] = Field(..., title="Dose weight")
    totalMotion: Optional[float] = Field(..., title="Total motion")
    averageMotionPerFrame: Optional[float] = Field(
        ..., title="Average motion per frame"
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


class TiltImageAlignmentOut(OrmBaseModel):
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


class FullMovie(OrmBaseModel):
    CTF: CTF
    Movie: Movie
    MotionCorrection: MotionCorrection
    TiltImageAlignment: Optional[TiltImageAlignmentOut] = None


class FullMovieWithTilt(Paged[FullMovie]):
    rawTotal: int


class CtfBase(OrmBaseModel):
    estimatedResolution: Optional[float]
    estimatedDefocus: Optional[float]
    astigmatism: Optional[float]


class CtfTiltAlign(CtfBase):
    refinedTiltAngle: Optional[float]


class CtfImageNumber(CtfBase):
    imageNumber: int


class CtfBaseSpa(CtfImageNumber):
    numberOfParticles: Optional[int]


class ItemList(BaseModel, Generic[T]):
    items: list[T]


class ProcessingJob(OrmBaseModel):
    processingJobId: int
    dataCollectionId: int
    displayName: Optional[str] = Field(..., max_length=80)
    comments: Optional[str] = Field(..., max_length=255)
    recordTimestamp: Optional[datetime]
    recipe: Optional[str] = Field(..., max_length=50)
    automatic: Optional[int]


class AutoProcProgram(OrmBaseModel):
    autoProcProgramId: int
    processingCommandLine: Optional[str] = Field(max_length=255)
    processingPrograms: Optional[str] = Field(max_length=255)
    processingStatus: Optional[int]
    processingMessage: Optional[str] = Field(max_length=255)
    processingStartTime: Optional[datetime]
    processingEndTime: Optional[datetime]
    processingEnvironment: Optional[str] = Field(max_length=255)
    recordTimeStamp: Optional[datetime]


class ProcessingJobResponse(OrmBaseModel):
    AutoProcProgram: Optional[AutoProcProgram]
    ProcessingJob: ProcessingJob
    status: str


class TomogramResponse(OrmBaseModel):
    tomogramId: int
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
    refinedTiltAxis: Optional[float] = None


class TomogramFullResponse(ProcessingJobResponse):
    Tomogram: Optional[TomogramResponse]


class ParticlePicker(OrmBaseModel):
    particleDiameter: Optional[float]
    numberOfParticles: Optional[int]
    particlePickerId: Optional[int]
    summaryFullImagePath: Optional[str] = None
    imageNumber: int
    movieId: int
    createdTimeStamp: Optional[datetime]


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
    classImageFullPath: Optional[str]
    particlesPerClass: Optional[int]
    rotationAccuracy: float
    translationAccuracy: float
    estimatedResolution: float
    overallFourierCompleteness: float
    classDistribution: Optional[float]
    selected: Optional[bool]
    bFactorFitIntercept: Optional[float] = None
    bFactorFitLinear: Optional[float] = None


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


class Atlas(BaseModel):
    atlasId: int
    pixelSize: float
    cassetteSlot: int
    dataCollectionGroupId: int


class FoilHole(BaseModel):
    diameter: int
    foilHoleId: int
    x: int = Field(validation_alias="pixelLocationX")
    y: int = Field(validation_alias="pixelLocationY")
