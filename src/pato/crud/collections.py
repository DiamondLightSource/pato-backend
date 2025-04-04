import json
import os
import re

from fastapi import HTTPException, status
from lims_utils.models import Paged
from lims_utils.tables import (
    CTF,
    AutoProcProgram,
    BLSession,
    DataCollection,
    DataCollectionGroup,
    MotionCorrection,
    Movie,
    ParticlePicker,
    ProcessingJob,
    ProcessingJobParameter,
    Proposal,
    TiltImageAlignment,
    Tomogram,
)
from sqlalchemy import (
    Column,
    ColumnElement,
    Select,
    and_,
    case,
    extract,
    func,
    select,
)

from ..crud.tomograms import get_slice_path
from ..models.reprocessing import (
    SPAReprocessingParameters,
    TomogramReprocessingParameters,
)
from ..models.response import (
    DataPoint,
    FullMovie,
    ItemList,
    ProcessingJobResponse,
    TomogramFullResponse,
)
from ..utils.database import db, paginate
from ..utils.generic import MovieType, check_session_active, parse_count
from ..utils.pika import PikaPublisher

_job_status_description = case(
    (AutoProcProgram.processingJobId == None, "Submitted"),  # noqa: E711
    (AutoProcProgram.processingStatus == 1, "Success"),
    (AutoProcProgram.processingStatus == 0, "Fail"),
    (
        and_(
            AutoProcProgram.processingStatus == None,  # noqa: E711
            AutoProcProgram.processingStartTime != None,  # noqa: E711
        ),
        "Running",
    ),
    else_="Queued",
)


def _generate_proc_job_params(proc_job_id: int | Column[int], params: dict):
    return [
        ProcessingJobParameter(
            processingJobId=proc_job_id, parameterKey=key, parameterValue=value
        )
        for (key, value) in params.items()
    ]


def _validate_session_active(collectionId: int):
    end_date = db.session.scalar(
        select(BLSession.endDate)
        .select_from(DataCollection)
        .filter_by(dataCollectionId=collectionId)
        .join(DataCollectionGroup)
        .join(BLSession)
    )

    if not check_session_active(end_date):
        raise HTTPException(
            status_code=status.HTTP_423_LOCKED,
            detail="Reprocessing cannot be fired on an inactive session",
        )


def get_tomograms(
    limit: int, page: int, collectionId: int
) -> Paged[TomogramFullResponse]:
    query = (
        select(
            Tomogram,
            AutoProcProgram,
            ProcessingJob,
            _job_status_description.label("status"),
        )
        .select_from(ProcessingJob)
        .outerjoin(AutoProcProgram)
        .outerjoin(Tomogram)
        .filter(ProcessingJob.dataCollectionId == collectionId)
        .order_by(ProcessingJob.processingJobId.desc())
    )

    return paginate(query, limit, page, slow_count=False)


def get_motion_correction(limit: int, page: int, collectionId: int) -> Paged[FullMovie]:
    query = (
        select(MotionCorrection, CTF, Movie)
        .filter(Movie.dataCollectionId == collectionId)
        .join(MotionCorrection, MotionCorrection.movieId == Movie.movieId)
        .join(CTF, CTF.motionCorrectionId == MotionCorrection.motionCorrectionId)
        .order_by(MotionCorrection.imageNumber)
        .group_by(Movie.movieId)
    )

    return paginate(query, limit, page, slow_count=True)


def initiate_reprocessing_tomogram(
    params: TomogramReprocessingParameters, collectionId: int
):
    _validate_session_active(collectionId)

    motion_correction_records = db.session.execute(
        select(MotionCorrection.movieId, MotionCorrection.micrographFullPath)
        .select_from(Tomogram)
        .filter_by(dataCollectionId=collectionId)
        .join(TiltImageAlignment)
        .join(MotionCorrection, MotionCorrection.movieId == TiltImageAlignment.movieId)
    ).all()

    input_file_list = []

    for record in motion_correction_records:
        # Users can modify the file name, and we cannot control where exactly the tilt
        # angle ends up, so we have to manually extract them from each file
        tilt_angle_regex = re.match(
            r".*_([-]?[0-9]+\.[0-9]+)_.*", record.micrographFullPath
        )

        if tilt_angle_regex is None:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Micrograph file name has no tilt angle",
            )

        try:
            input_file_list.append(
                (
                    record.micrographFullPath,
                    float(tilt_angle_regex.group(1)),
                    # record.movieId,
                )
            )
        except ValueError:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Micrograph file name has invalid tilt angle",
            )

    if len(input_file_list) == 0:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Data collection has no valid motion correction records",
        )

    stack_files = db.session.scalars(
        select(Tomogram.stackFile)
        .filter_by(dataCollectionId=collectionId)
        .order_by(Tomogram.tomogramId)
        .limit(3)
    ).all()

    if stack_files is None or len(stack_files) == 0:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No valid tomogram found in collection for reprocessing",
        )

    if len(stack_files) > 2:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Too many autoprocessing programs already exist",
        )

    stack_file: str = stack_files[0]

    stack_file_regex = re.match(r".*\_reprocess([0-9]+)", stack_file)

    # The stack file name should be the name of a stack file present in one of the
    # tomograms, with an unique suffix
    if stack_file_regex is not None:
        index = int(stack_file_regex.group(1)) + 1
        stack_file = f"{stack_file.split('_reprocess')[0]}_reprocess{index}.mrc"
    else:
        stack_file = f"{os.path.splitext(stack_file)[0]}_reprocess1.mrc"

    proc_job_params = {
        "path_pattern": "",
        "dcid": collectionId,
        "stack_file": stack_file,
        "pix_size": params.pixelSize,
        "manual_tilt_offset": params.tiltOffset,
    }

    new_job = ProcessingJob(
        displayName="Tomogram Reconstruction",
        recipe="em-tomo-align-reproc",
        dataCollectionId=collectionId,
    )
    db.session.add(new_job)
    db.session.flush()

    db.session.bulk_save_objects(
        _generate_proc_job_params(new_job.processingJobId, proc_job_params)
    )

    # Changes should be persisted in database before message is sent, or else pipeline
    # will fail
    db.session.commit()

    message = {
        "recipes": ["em-tomo-align"],
        "parameters": {
            "input_file_list": input_file_list,
            # This is not a typo, the expected key for the processing job ID is appid
            "appid": new_job.processingJobId,
            **proc_job_params,
        },
    }

    with PikaPublisher() as pika_publisher:
        pika_publisher.publish(json.dumps(message))

    return {"processingJobId": new_job.processingJobId}


def initiate_reprocessing_spa(params: SPAReprocessingParameters, collectionId: int):
    _validate_session_active(collectionId)

    session = db.session.execute(
        select(
            DataCollection.imageDirectory,
            DataCollection.imageSuffix,
            BLSession.beamLineName,
            extract("year", BLSession.startDate).label("year"),
            func.concat(
                Proposal.proposalCode,
                Proposal.proposalNumber,
                "-",
                BLSession.visit_number,
            ).label("name"),
        )
        .filter(DataCollection.dataCollectionId == collectionId)
        .select_from(DataCollection)
        .join(DataCollectionGroup)
        .join(BLSession)
        .join(Proposal)
    ).one()

    # TODO: Make the gain reference path string pattern configurable?
    gr_path = f"/dls/{session.beamLineName}/data/{session.year}/{session.name}/processing/{params.motioncor_gainreference}"  # noqa: E501

    full_params = {
        **params.model_dump(exclude_none=True),
        "import_images": f"{session.imageDirectory}/GridSquare*/Data/*{session.imageSuffix}",
        "motioncor_gainreference": gr_path,
    }

    new_job = ProcessingJob(
        displayName="RELION",
        recipe="relion",
        automatic=0,
        comments="Submitted via PATo",
        dataCollectionId=collectionId,
    )
    db.session.add(new_job)
    db.session.flush()

    db.session.bulk_save_objects(
        _generate_proc_job_params(new_job.processingJobId, full_params)
    )
    db.session.commit()

    message = {"parameters": {"ispyb_process": new_job.processingJobId}}

    with PikaPublisher() as pika_publisher:
        pika_publisher.publish(json.dumps(message))

    return {"processingJobId": new_job.processingJobId}


def get_processing_jobs(
    limit: int,
    page: int,
    collectionId: int,
    search: str,
) -> Paged[ProcessingJobResponse]:
    query = (
        select(AutoProcProgram, ProcessingJob, _job_status_description.label("status"))
        .select_from(ProcessingJob)
        .outerjoin(AutoProcProgram)
        .filter(ProcessingJob.dataCollectionId == collectionId)
        .order_by(
            ProcessingJob.recipe.desc(),
            ProcessingJob.processingJobId.desc(),
            AutoProcProgram.autoProcProgramId.desc(),
        )
    )

    return paginate(query, limit, page, slow_count=False)


def _with_ctf_joins(query: Select, collectionId: int):
    return (
        query.select_from(ProcessingJob)
        .filter(ProcessingJob.dataCollectionId == collectionId)
        .join(AutoProcProgram)
        .join(MotionCorrection)
        .join(CTF, CTF.motionCorrectionId == MotionCorrection.motionCorrectionId)
        .join(
            ParticlePicker,
            ParticlePicker.firstMotionCorrectionId
            == MotionCorrection.motionCorrectionId,
        )
    )


def get_ctf(collectionId: int):
    data = db.session.execute(
        _with_ctf_joins(
            select(
                CTF.estimatedDefocus.label("x"),
                ParticlePicker.numberOfParticles.label("y"),
            ),
            collectionId,
        ).group_by(MotionCorrection.imageNumber)
    ).all()

    return ItemList[DataPoint](items=data)


def _histogram_sum_bin(condition: ColumnElement):
    return func.coalesce(
        func.sum(
            case(
                (
                    condition,
                    ParticlePicker.numberOfParticles,
                ),
            )
        ),
        0,
    )


def get_particle_count_per_resolution(collectionId: int) -> ItemList[DataPoint]:
    data = parse_count(
        _with_ctf_joins(
            select(
                _histogram_sum_bin(CTF.estimatedResolution < 1).label("<1"),
                *[
                    _histogram_sum_bin(
                        and_(
                            CTF.estimatedResolution >= i,
                            CTF.estimatedResolution < i + 1,
                        )
                    ).label(str(i))
                    for i in range(1, 8)
                ],
                _histogram_sum_bin(CTF.estimatedResolution >= 9).label(">9"),
            ),
            collectionId,
        )
    )

    return data


def get_central_slice(collection_id: int, movie_type: MovieType = None) -> str:
    tomogram_id = db.session.scalar(
        select(Tomogram.tomogramId)
        .filter(Tomogram.dataCollectionId == collection_id)
        .limit(1)
    )

    if tomogram_id is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Data collection has no tomograms",
        )

    return get_slice_path(tomogram_id, movie_type)
