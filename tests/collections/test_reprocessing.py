from sqlalchemy import select

from pato.models.table import ProcessingJob, ProcessingJobParameter
from pato.utils.database import db


def test_post_user(mock_permissions, client):
    """Start reprocessing job for data collection"""
    resp = client.post(
        "/dataCollections/6017406/reprocessing/tomograms",
        json={"pixelSize": 1, "tiltOffset": 1},
    )
    assert resp.status_code == 202

    proc_id = db.session.scalars(
        select(ProcessingJob.processingJobId)
        .filter(ProcessingJob.dataCollectionId == 6017406)
        .order_by(ProcessingJob.processingJobId.desc())
    ).first()

    # Should create five entries in the processing job parameters table with the
    # respective given values

    assert (
        len(
            db.session.scalars(
                select(ProcessingJobParameter).filter(
                    ProcessingJobParameter.processingJobId == proc_id
                )
            ).all()
        )
        == 5
    )


def test_post_custom(mock_permissions, client):
    """Starts reprocessing job with custom parameters"""
    resp = client.post(
        "/dataCollections/6017406/reprocessing/tomograms",
        json={"pixelSize": 51, "tiltOffset": 1},
    )
    assert resp.status_code == 202

    proc_id = db.session.scalars(
        select(ProcessingJob.processingJobId)
        .filter(ProcessingJob.dataCollectionId == 6017406)
        .order_by(ProcessingJob.processingJobId.desc())
    ).first()

    # Values added should match user provided values

    assert (
        db.session.scalars(
            select(ProcessingJobParameter.parameterValue).filter(
                ProcessingJobParameter.processingJobId == proc_id,
                ProcessingJobParameter.parameterKey == "pix_size",
            )
        ).one()
        == "51"
    )


def test_post_message(mock_permissions, mock_pika, client):
    """Starts reprocessing job with custom parameters"""
    resp = client.post(
        "/dataCollections/6017406/reprocessing/tomograms",
        json={"pixelSize": 51, "tiltOffset": 1},
    )
    assert resp.status_code == 202

    proc_id = db.session.scalars(
        select(ProcessingJob.processingJobId)
        .filter(ProcessingJob.dataCollectionId == 6017406)
        .order_by(ProcessingJob.processingJobId.desc())
    ).first()

    mock_pika.publish.assert_called_with(
        (
            '{"parameters": {"input_file_list": '
            '[["/dls/m02/raw/Position_2_11_45.00_abc.jpeg", 45.0, 1], '
            '["/dls/m02/raw/Position_2_11_45.00_abc.jpeg", 45.0, 2], '
            '["/dls/m02/raw/Position_2_11_45.00_abc.jpeg", 45.0, 3], '
            '["/dls/m02/raw/Position_2_11_45.00_abc.jpeg", 45.0, 4]], '
            f'"proc_job": {proc_id}{"}}"}'
        ),
    )


def test_no_tomogram(mock_permissions, client):
    """Try to process data collection with no tomogram"""
    resp = client.post(
        "/dataCollections/993677/reprocessing/tomograms",
        json={"pixelSize": 51, "tiltOffset": 1},
    )

    assert resp.status_code == 404


def test_tomogram_too_many(mock_permissions, client):
    """Try to process data collection with too many (3) tomograms already processed"""
    resp = client.post(
        "/dataCollections/6017408/reprocessing/tomograms",
        json={"pixelSize": 51, "tiltOffset": 1},
    )

    assert resp.status_code == 400


def test_tomogram_no_tilt(mock_permissions, client):
    """Try to process data collection tomogram with no tilt alignment data"""
    resp = client.post(
        "/dataCollections/6017409/reprocessing/tomograms",
        json={"pixelSize": 51, "tiltOffset": 1},
    )

    assert resp.status_code == 404


def test_tomogram_no_stack(mock_permissions, client):
    """Try to process data collection tomogram with no stack file"""
    resp = client.post(
        "/dataCollections/6017409/reprocessing/tomograms",
        json={"pixelSize": 51, "tiltOffset": 1},
    )

    assert resp.status_code == 404


def test_tomogram_invalid_micrograph(mock_permissions, client):
    """Try to process data collection tomogram with invalid micrograph name"""
    resp = client.post(
        "/dataCollections/6017413/reprocessing/tomograms",
        json={"pixelSize": 51, "tiltOffset": 1},
    )

    assert resp.status_code == 500


def test_tomogram_with_suffix(mock_permissions, client):
    """Process tomogram with cardinal suffix on stack file name"""
    resp = client.post(
        "/dataCollections/6017406/reprocessing/tomograms",
        json={"pixelSize": 51, "tiltOffset": 1},
    )

    assert resp.status_code == 202

    proc_id = db.session.scalars(
        select(ProcessingJob.processingJobId)
        .filter(ProcessingJob.dataCollectionId == 6017406)
        .order_by(ProcessingJob.processingJobId.desc())
    ).first()

    assert (
        db.session.scalars(
            select(ProcessingJobParameter.parameterValue).filter(
                ProcessingJobParameter.processingJobId == proc_id,
                ProcessingJobParameter.parameterKey == "stack_file",
            )
        ).one()
        == "/dls/m02/data/align_output/Position_1_9_stack(2).mrc"
    )
