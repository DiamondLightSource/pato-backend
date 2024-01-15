import pytest

from pato.models.parameters import (
    SPAReprocessingParameters,
    _omit_when_autocalculating,
    _omit_when_stopping,
)

_base = {
    "pixelSize": 0.05,
    "dosePerFrame": 1,
    "maskDiameter": 4,
    "boxSize": 3,
    "downsampleBoxSize": 4,
}


def test_fields_omitted_with_stop_after_ctf():
    """Some fields must be omitted when opting to stop after CTF estimation"""
    params = SPAReprocessingParameters(**_base, stopAfterCtfEstimation=True).dict()
    assert not any(x in params.keys() for x in _omit_when_stopping)


def test_fields_included_with_no_stop_after_ctf():
    """All fields must be present when not stopping after CTF estimation"""
    params = SPAReprocessingParameters(
        **_base,
        stopAfterCtfEstimation=False,
        minimumDiameter=3,
        maximumDiameter=4,
        performCalculation=False,
    ).dict()
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
    """Some fiels must be omitted when autocalcutation is selected"""
    params = SPAReprocessingParameters(
        **_base,
        stopAfterCtfEstimation=False,
        minimumDiameter=3,
        maximumDiameter=4,
        performCalculation=True,
    ).dict()
    assert not any(x in params.keys() for x in _omit_when_autocalculating)
