from typing import Literal, Optional

from pydantic import BaseModel, Field, model_validator

from ..utils.generic import filter_model

_omit_when_stopping = [
    "autopick_do_cryolo",
    "do_class2d",
    "do_class3d",
    "mask_diameter",
    "extract_boxsize",
    "autopick_LoG_diam_min",
    "autopick_LoG_diam_max",
    "use_fsc_criterion",
    "extract_downscale",
]

_omit_when_autocalculating = [
    "mask_diameter",
    "extract_box_size",
]


class TomogramReprocessingParameters(BaseModel):
    pixelSize: int
    tiltOffset: float


# The weird field names are due to the names the pipeline expects from ISPyB
class SPAReprocessingParameters(BaseModel):
    voltage: Literal[200, 300] = 300
    Cs: float = Field(default=2.7, alias="sphericalAberration")
    ctffind_do_phaseshift: bool = Field(default=False, alias="phasePlateUsed")
    angpix: float = Field(ge=0.02, lt=100, alias="pixelSize")
    motioncor_binning: Literal[1, 2] = Field(default=1, alias="motionCorrectionBinning")
    motioncor_doseperframe: float = Field(ge=0.003, lt=5, alias="dosePerFrame")
    stop_after_ctf_estimation: bool = Field(
        default=False, alias="stopAfterCtfEstimation"
    )
    autopick_do_cryolo: bool = Field(
        description="Use crYOLO with autopick. Academic users only.",
        alias="useCryolo",
        default=False,
    )
    do_class3d: Optional[bool] = Field(default=True, alias="doClass3D")
    do_class2d: Optional[bool] = Field(default=True, alias="doClass2D")
    mask_diameter: Optional[float] = Field(
        ge=0.1, le=1024, alias="maskDiameter", default=None
    )
    extract_boxsize: Optional[float] = Field(
        ge=0.1, le=1024, alias="boxSize", default=None
    )
    performCalculation: bool = Field(default=True, exclude=True)
    use_fsc_criterion: Optional[bool] = Field(default=False, alias="useFscCriterion")
    autopick_LoG_diam_min: Optional[float] = Field(
        ge=0.02, le=1024.0, alias="minimumDiameter", default=None
    )
    autopick_LoG_diam_max: Optional[float] = Field(
        ge=0.02, le=4000.0, alias="maximumDiameter", default=None
    )
    motioncor_gainreference: str = Field(default="gain.mrc", alias="gainReferenceFile")
    extract_downscale: Optional[bool] = Field(default=True, alias="extractDownscale")

    @model_validator(mode="before")
    def empty_string_to_none(cls, values):
        for key, value in values.items():
            if value == "":
                values[key] = None

        return values

    @model_validator(mode="after")
    def check_dynamically_required_fields(self):
        if self.stop_after_ctf_estimation:
            filter_model(self, _omit_when_stopping)
            if not self.do_class3d:
                filter_model(self, ["useFscCriterion"])
        else:
            if self.performCalculation:
                filter_model(self, _omit_when_autocalculating)

            required = [
                "autopick_LoG_diam_min",
                "autopick_LoG_diam_max",
            ]

            missing_keys = [key for key in required if getattr(self, key) is None]

            if len(missing_keys) > 0:
                raise ValueError(
                    " and ".join(missing_keys)
                    + " must be set when stopAfterCtfEstimation is not set"
                )

            assert isinstance(self.autopick_LoG_diam_min, float) and isinstance(
                self.autopick_LoG_diam_max, float
            )

            if self.autopick_LoG_diam_min > self.autopick_LoG_diam_max:
                raise ValueError("maximumDiameter must be greater than minimumDiameter")

        return self
