from datetime import datetime
from enum import Enum
from typing import Literal, Optional

from pydantic import BaseModel, Field, field_validator

from .response import OrmBaseModel


class RotationAxisEnum(str, Enum):
    omega = "Omega"
    kappa = "Kappa"
    phi = "Phi"


class DataCollectionCreationParameters(BaseModel):
    fileDirectory: str
    fileExtension: str


class DataCollectionFileAttachmentOut(OrmBaseModel):
    dataCollectionFileAttachmentId: int
    fileType: str
    createTime: datetime


class BaseDataCollectionOut(OrmBaseModel):
    dataCollectionId: int = Field(..., lt=1e9, description="Data Collection ID")
    dataCollectionGroupId: int
    index: Optional[int] = None
    startTime: Optional[datetime] = Field(
        None, description="Start time of the dataCollection"
    )
    endTime: Optional[datetime] = Field(
        None, description="End time of the dataCollection"
    )
    experimenttype: Optional[str] = Field(None, max_length=24)
    fileTemplate: Optional[str] = Field(None, max_length=255)
    imageSuffix: Optional[str] = Field(None, max_length=24)
    imageDirectory: Optional[str] = Field(
        None,
        max_length=255,
        description="The directory where files reside - should end with a slash",
    )
    imagePrefix: Optional[str] = Field(None, max_length=45)


class DataCollectionSummary(BaseDataCollectionOut):
    comments: Optional[str] = None
    pixelSizeOnImage: Optional[float] = Field(
        None,
        description="Pixel size on image, calculated from magnification",
    )
    voltage: Optional[float] = None
    imageSizeX: Optional[int] = Field(
        None,
        description="Image size in x, in case crop has been used.",
    )
    imageSizeY: Optional[int] = Field(
        None, description="Image size in y, in case crop has been used."
    )
    runStatus: Optional[str] = Field(None, max_length=255)
    axisStart: Optional[float] = None
    axisEnd: Optional[float] = None
    axisRange: Optional[float] = None
    overlap: Optional[float] = None
    numberOfImages: Optional[int] = None
    startImageNumber: Optional[int] = None
    numberOfPasses: Optional[int] = None
    exposureTime: Optional[float] = None
    imageContainerSubPath: Optional[str] = Field(
        None,
        max_length=255,
        description="""Internal path of a HDF5 file pointing to the data
        for this data collection""",
    )
    wavelength: Optional[float] = None
    resolution: Optional[float] = None
    detectorDistance: Optional[float] = None
    xBeam: Optional[float] = None
    yBeam: Optional[float] = None
    printableForReport: Optional[int] = None
    slitGapVertical: Optional[float] = None
    slitGapHorizontal: Optional[float] = None
    transmission: Optional[float] = None
    synchrotronMode: Optional[str] = Field(None, max_length=20)
    xtalSnapshotFullPath1: Optional[str] = Field(None, max_length=255)
    xtalSnapshotFullPath2: Optional[str] = Field(None, max_length=255)
    xtalSnapshotFullPath3: Optional[str] = Field(None, max_length=255)
    xtalSnapshotFullPath4: Optional[str] = Field(None, max_length=255)
    rotationAxis: Optional[RotationAxisEnum] = None
    phiStart: Optional[float] = None
    kappaStart: Optional[float] = None
    omegaStart: Optional[float] = None
    chiStart: Optional[float] = None
    detector2Theta: Optional[float] = None
    undulatorGap1: Optional[float] = None
    undulatorGap2: Optional[float] = None
    undulatorGap3: Optional[float] = None
    beamSizeAtSampleX: Optional[float] = None
    beamSizeAtSampleY: Optional[float] = None
    centeringMethod: Optional[str] = Field(None, max_length=255)
    detectorId: Optional[int] = None
    flux: Optional[float] = None
    blSubSampleId: Optional[int] = None
    flux_end: Optional[float] = None
    datFullPath: Optional[str] = Field(None, max_length=255)
    magnification: Optional[float] = None
    totalAbsorbedDose: Optional[float] = None
    binning: Optional[int] = None
    particleDiameter: Optional[float] = None
    minResolution: Optional[float] = None
    minDefocus: Optional[float] = None
    maxDefocus: Optional[float] = None
    defocusStepSize: Optional[float] = None
    c2aperture: Optional[float] = None
    totalExposedDose: Optional[float] = None
    phasePlate: Optional[str] = None
    dataCollectionPlanId: Optional[int] = None
    globalAlignmentQuality: Optional[float] = None
    tomograms: int

    @field_validator("phasePlate", mode="before")
    def to_bool_str(cls, v):
        phase_plate_used = v is not None and v != "0" and v != 0
        return "Yes" if phase_plate_used else "No"

    @field_validator("pixelSizeOnImage")
    def to_angstrom(cls, v):
        return v if v is None else v * 10


# mypy doesn't support type aliases yet

DataCollectionSortTypes = Literal["dataCollectionId", "globalAlignmentQuality", ""]
