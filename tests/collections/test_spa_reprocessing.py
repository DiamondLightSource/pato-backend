from unittest.mock import patch

import pytest
from sqlalchemy import select

from pato.models.table import ProcessingJobParameter
from pato.utils.database import db


def active_mock(collectionId: int):
    return


full_params = {
    "voltage": 300,
    "sphericalAberration": 2.7,
    "phasePlateUsed": "0",
    "pixelSize": "1.2",
    "motionCorrectionBinning": 1,
    "dosePerFrame": "0.986",
    "stopAfterCtfEstimation": False,
    "doClass2D": True,
    "doClass3D": False,
    "useCryolo": True,
    "minimumDiameter": "120",
    "maximumDiameter": "140",
    "maskDiameter": "154",
    "boxSize": "140",
    "downsampleBoxSize": "48",
    "import_images": "/dls/m06/data/2022/bi23047-76/raw//GridSquare_*/Data/*.mrc",
    "acquisition_software": "EPU",
    "gainReferenceFile": "gain.mrc",
    "performCalculation": False,
    "useFscCriterion": False,
    "perform2DSecondPass": False,
    "perform3DSecondPass": False,
}


def _get_parameters(proc_job_id: int):
    return db.session.scalars(
        select(ProcessingJobParameter).filter(
            ProcessingJobParameter.processingJobId == proc_job_id
        )
    ).all()


@patch("pato.crud.collections._validate_session_active", new=active_mock)
def test_post(mock_permissions, client):
    """Start reprocessing job for data collection"""
    resp = client.post(
        "/dataCollections/6017405/reprocessing/spa",
        json=full_params,
    )
    assert resp.status_code == 202

    parameters = _get_parameters(resp.json()["processingJobId"])
    assert len(parameters) == 21


def test_inactive_session(mock_permissions, client):
    """Try to start reprocessing on inactive session"""
    with patch("pato.crud.collections.check_session_active") as patched_session_check:
        patched_session_check.return_value = False
        resp = client.post(
            "/dataCollections/6017405/reprocessing/spa",
            json=full_params,
        )
        assert resp.status_code == 423


@patch("pato.crud.collections._validate_session_active", new=active_mock)
def test_post_stop_after_ctf_estimation(mock_permissions, client):
    """Start reprocessing job for data collection, stopping after CTF estimation"""
    resp = client.post(
        "/dataCollections/6017405/reprocessing/spa",
        json={**full_params, "stopAfterCtfEstimation": True},
    )
    assert resp.status_code == 202

    parameters = _get_parameters(resp.json()["processingJobId"])
    assert len(parameters) == 9


@patch("pato.crud.collections._validate_session_active", new=active_mock)
def test_post_perform_calculation(mock_permissions, client):
    """Start reprocessing job for data collection, calculating values for user"""
    resp = client.post(
        "/dataCollections/6017405/reprocessing/spa",
        json={**full_params, "performCalculation": True},
    )
    assert resp.status_code == 202

    parameters = _get_parameters(resp.json()["processingJobId"])
    assert len(parameters) == 19


@patch("pato.crud.collections._validate_session_active", new=active_mock)
@pytest.mark.parametrize(
    ["key", "expected_value"],
    [
        ["motioncor_gainreference", "/dls/i03/data/2015/cm14451-1/processing/gain.mrc"],
        [
            "import_images",
            "/dls/i03/data/2021/proposal/data/file.h5",
        ],
    ],
)
@patch("pato.crud.collections._validate_session_active", new=active_mock)
def test_generated_paths(key, expected_value, mock_permissions, client):
    """Build file paths dynamically and insert them into the appropriate columns"""
    resp = client.post(
        "/dataCollections/6017405/reprocessing/spa",
        json=full_params,
    )
    assert resp.status_code == 202

    value = db.session.scalar(
        select(ProcessingJobParameter.parameterValue).filter(
            ProcessingJobParameter.processingJobId == resp.json()["processingJobId"],
            ProcessingJobParameter.parameterKey == key,
        )
    )

    assert value == expected_value
