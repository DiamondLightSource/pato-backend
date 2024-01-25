import pytest

from pato.models.parameters import SPAReprocessingParameters

_base = {
    "pixelSize": 0.05,
    "dosePerFrame": 1,
    "maskDiameter": 4,
    "boxSize": 3,
    "downsampleBoxSize": 4,
}

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


def test_fields_omitted_with_stop_after_ctf():
    """Some fields must be omitted when opting to stop after CTF estimation"""
    params = SPAReprocessingParameters(**_base, stopAfterCtfEstimation=True).model_dump(
        exclude_none=True
    )

    assert not any(x in params.keys() for x in _omit_when_stopping)


def test_fields_included_with_no_stop_after_ctf():
    """All fields must be present when not stopping after CTF estimation"""
    params = SPAReprocessingParameters(
        **_base,
        stopAfterCtfEstimation=False,
        minimumDiameter=3,
        maximumDiameter=4,
        performCalculation=False,
    ).model_dump()
    assert set(_omit_when_stopping).issubset({*params.keys()})


def test_invalid_diameter_size():
    """Invalid diameter types should raise exception"""
    with pytest.raises(ValueError):
        SPAReprocessingParameters(
            **_base, stopAfterCtfEstimation=False, minimumDiameter=5, maximumDiameter=4
        )


def test_no_diameter_size_with_no_stop_after_ctf():
    """No diameter sizes when stopping after CTF is opted for should raise an
    exception"""
    with pytest.raises(ValueError):
        SPAReprocessingParameters(**_base, stopAfterCtfEstimation=False)


def test_field_omitted_when_autocalculating():
    """Some fields must be omitted when autocalcutation is selected"""
    params = SPAReprocessingParameters(
        **_base,
        stopAfterCtfEstimation=False,
        minimumDiameter=3,
        maximumDiameter=4,
        performCalculation=True,
    ).model_dump(exclude_none=True)
    assert not any(x in params.keys() for x in _omit_when_autocalculating)


def test_empty_string_to_none():
    """Fields populated with empty strings should be none"""
    params = SPAReprocessingParameters(
        pixelSize=0.05,
        dosePerFrame=1,
        minimumDiameter=3,
        maximumDiameter=4,
        maskDiameter="",
        downsampleBoxSize="",
    )

    assert params.mask_diameter is None
    assert params.extract_small_boxsize is None
