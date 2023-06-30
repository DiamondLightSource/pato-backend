import json
import os
import re

from fastapi import HTTPException, status
from sqlalchemy import Column, and_, case, select

from ..models.parameters import (
    SPAReprocessingParameters,
    TomogramReprocessingParameters,
)
from ..models.response import FullMovie, ProcessingJobResponse, TomogramFullResponse
from ..models.table import (
    CTF,
    AutoProcProgram,
    MotionCorrection,
    Movie,
    ProcessingJob,
    ProcessingJobParameter,
    TiltImageAlignment,
    Tomogram,
)
from ..utils.database import Paged, db, paginate
from ..utils.pika import pika_publisher

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
        .join(AutoProcProgram)
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
    new_job = ProcessingJob(
        displayName="Tomogram Reconstruction",
        recipe="em-tomo-align-reproc",
        dataCollectionId=collectionId,
    )
    db.session.add(new_job)
    db.session.flush()

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
                    record.movieId,
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

    stack_files = db.session.execute(
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

    stack_file: str = stack_files[0].stackFile
    stack_file_regex = re.match(r".*\(([0-9]+)\)", stack_file)

    # The stack file name should be the name of a stack file present in one of the
    # tomograms, with an unique suffix
    if stack_file_regex is not None:
        stack_file = (
            f"{stack_file.split('(')[0]}({int(stack_file_regex.group(1))+1}).mrc"
        )
    else:
        stack_file = f"{os.path.splitext(stack_file)[0]}(1).mrc"

    proc_job_params = {
        "pix_size": params.pixelSize,
        "manual_tilt_offset": params.tiltOffset,
        "dcid": collectionId,
        "stack_file": stack_file,
        "movie_id": input_file_list[0][2],
    }

    db.session.bulk_save_objects(
        _generate_proc_job_params(new_job.processingJobId, proc_job_params)
    )

    # Changes should be persisted in database before message is sent, or else pipeline
    # will fail
    db.session.commit()

    message = {
        "parameters": {
            "input_file_list": input_file_list,
            "proc_job": new_job.processingJobId,
        },
    }

    pika_publisher.publish(json.dumps(message))

    return {"processingJobId": new_job.processingJobId}


def initiate_reprocessing_spa(params: SPAReprocessingParameters, collectionId: int):
    raise NotImplementedError()


def get_processing_jobs(
    limit: int,
    page: int,
    collectionId: int,
    search: str,
) -> Paged[ProcessingJobResponse]:
    query = (
        select(AutoProcProgram, ProcessingJob, _job_status_description.label("status"))
        .select_from(ProcessingJob)
        .join(AutoProcProgram)
        .filter(ProcessingJob.dataCollectionId == collectionId)
        .order_by(ProcessingJob.processingJobId.desc())
    )

    return paginate(query, limit, page, slow_count=False)
