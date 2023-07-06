from typing import Literal, Optional

from pydantic import BaseModel, Field, root_validator

from ..utils.generic import filter_dict

_omit_when_stopping = [
    "autopick_do_cryolo",
    "do_class2d",
    "do_class3d",
    "mask_diameter",
    "extract_boxsize",
    "extract_small_boxsize",
    "do_class2d_pass2",
    "do_class3d_pass2",
    "autopick_LoG_diam_min",
    "autopick_LoG_diam_max",
    "use_fsc_criterion",
    "extract_downscale",
]

_omit_when_autocalculating = [
    "mask_diameter",
    "extract_box_size",
    "extract_small_boxsize",
]


class TomogramReprocessingParameters(BaseModel):
    pixelSize: int
    tiltOffset: float


# The weird field names are due to the names the pipeline expects from ISPyB
class SPAReprocessingParameters(BaseModel):
    voltage: Literal[200, 300] = 300
    Cs: float = Field(default=2.7, alias="sphericalAberration")
    ctffind_do_phaseshift: bool = Field(default=False, alias="phasePlateUsed")
    angpix: float = Field(min=0.02, max=100, alias="pixelSize")
    motioncor_binning: Literal[1, 2] = Field(default=1, alias="motionCorrectionBinning")
    motioncor_doseperframe: float = Field(min=0.003, max=5, alias="dosePerFrame")
    stop_after_ctf_estimation: bool = Field(
        default=False, alias="stopAfterCtfEstimation"
    )
    autopick_do_cryolo: bool = Field(
        description="Use crYOLO with autopick. Academic users only.",
        alias="useCryolo",
        default=False,
    )
    do_class3d: bool = Field(default=True, alias="doClass3D")
    do_class2d: bool = Field(default=True, alias="doClass2D")
    mask_diameter: float = Field(
        min=0.1,
        max=1024,
        alias="maskDiameter",
    )
    extract_boxsize: float = Field(min=0.1, max=1024, alias="boxSize")
    extract_small_boxsize: float = Field(min=0.1, max=1024, alias="downsampleBoxSize")
    performCalculation: bool = Field(default=True, exclude=True)
    use_fsc_criterion: bool = Field(default=False, alias="useFscCriterion")
    do_class2d_pass2: bool = Field(default=True, alias="perform2DSecondPass")
    do_class3d_pass2: bool = Field(default=False, alias="perform3DSecondPass")
    autopick_LoG_diam_min: Optional[float] = Field(
        min=0.02, max=1024.0, alias="minimumDiameter"
    )
    autopick_LoG_diam_max: Optional[float] = Field(
        min=0.02, max=4000.0, alias="maximumDiameter"
    )
    motioncor_gainreference: str = Field(default="gain.mrc", alias="gainReferenceFile")
    extract_downscale: bool = Field(default=False, alias="extractDownscale")

    @root_validator(skip_on_failure=True)
    def check_dynamically_required_fields(cls, values):
        if values.get("stop_after_ctf_estimation"):
            values = filter_dict(values, _omit_when_stopping)
            if not values.get("do_class_3d"):
                filter_dict(values, ["use_fsc_criterion"])
        else:
            if values.get("performCalculation"):
                values = filter_dict(values, _omit_when_autocalculating)

            alias_map = {
                "autopick_LoG_diam_min": "minimumDiameter",
                "autopick_LoG_diam_max": "maximumDiameter",
            }
            missing_keys = [
                value for key, value in alias_map.items() if values.get(key) is None
            ]

            if len(missing_keys) > 0:
                raise ValueError(
                    " and ".join(missing_keys)
                    + " must be set when stopAfterCtfEstimation is set"
                )

            if values.get("autopick_LoG_diam_min") > values.get(
                "autopick_LoG_diam_max"
            ):
                raise ValueError("maximumDiameter must be greater than minimumDiameter")

        return values
