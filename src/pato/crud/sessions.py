import pathlib
import shutil
from datetime import datetime
from typing import Optional

from fastapi import HTTPException, UploadFile, status
from lims_utils.auth import GenericUser
from lims_utils.logging import app_logger
from lims_utils.models import Paged
from lims_utils.tables import BLSession, DataCollection, DataCollectionGroup, Proposal
from sqlalchemy import Label, and_, func, insert, or_, select

from ..models.parameters import DataCollectionCreationParameters
from ..models.response import SessionAllowsReprocessing, SessionResponse
from ..utils.auth import check_session
from ..utils.config import Config
from ..utils.database import db, paginate, unravel
from ..utils.generic import ProposalReference, check_session_active, parse_proposal

HDF5_FILE_SIGNATURE = b"\x89\x48\x44\x46\x0d\x0a\x1a\x0a"


def _validate_session_active(proposal_reference: ProposalReference):
    """Check if session is active and return session ID"""
    session = db.session.scalar(
        select(BLSession)
        .select_from(Proposal)
        .join(BLSession)
        .filter(
            BLSession.visit_number == proposal_reference.visit_number,
            Proposal.proposalNumber == proposal_reference.number,
            Proposal.proposalCode == proposal_reference.code,
        )
    )

    if not check_session_active(session.endDate):
        raise HTTPException(
            status_code=status.HTTP_423_LOCKED,
            detail="Reprocessing cannot be fired on an inactive session",
        )

    assert session is not None

    return session


def _get_folder_and_visit(prop_ref: ProposalReference):
    session = _validate_session_active(prop_ref)
    year = session.startDate.year

    # TODO: Make the path string pattern configurable?
    return (
        f"/dls/{session.beamLineName}/data/{year}/{prop_ref.code}{prop_ref.number}-{prop_ref.visit_number}",
        session,
    )


def _check_raw_files_exist(file_directory: str, glob_path: str):
    """Check if raw data files exist in the filesystem"""
    if not any(pathlib.Path(file_directory).glob(glob_path)):
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No raw files found in session directory",
        )


def get_sessions(
    limit: int,
    page: int,
    user: GenericUser,
    proposal: Optional[str],
    search: Optional[str],
    minEndDate: Optional[datetime],
    maxEndDate: Optional[datetime],
    minStartDate: Optional[datetime],
    maxStartDate: Optional[datetime],
    countCollections: bool,
) -> Paged[SessionResponse]:
    fields: list[Label[str] | Label[int]] = [
        func.concat(Proposal.proposalCode, Proposal.proposalNumber).label(
            "parentProposal"
        )
    ]

    if countCollections:
        fields.append(
            func.count(DataCollectionGroup.dataCollectionGroupId.distinct()).label(
                "collectionGroups"
            )
        )

    query = select(*unravel(BLSession), *fields).filter(
        BLSession.beamLineName.like("m%"),
    )

    if proposal is not None:
        proposal_reference = parse_proposal(proposal)
        query = (
            query.join(Proposal)
            .filter(
                and_(
                    Proposal.proposalCode == proposal_reference.code,
                    Proposal.proposalNumber == proposal_reference.number,
                )
            )
            .order_by(BLSession.visit_number.desc())
        )
    else:
        query = query.join(Proposal).order_by(BLSession.endDate.desc())

    if minEndDate is not None:
        query = query.filter(BLSession.endDate >= minEndDate)

    if maxEndDate is not None:
        query = query.filter(BLSession.endDate <= maxEndDate)

    if minStartDate is not None:
        query = query.filter(BLSession.startDate >= minStartDate)

    if maxStartDate is not None:
        query = query.filter(BLSession.startDate <= maxStartDate)

    if search is not None and search != "":
        query = query.filter(
            or_(
                BLSession.beamLineName.contains(search),
                BLSession.visit_number.contains(search),
            )
        )

    query = check_session(query, user)

    if countCollections:
        query = query.join(
            DataCollectionGroup,
            DataCollectionGroup.sessionId == BLSession.sessionId,
            isouter=True,
        ).group_by(BLSession.visit_number, BLSession.proposalId)

    return paginate(query, limit, page)


def get_session(proposalReference: ProposalReference):
    query = (
        select(
            *unravel(BLSession),
            func.concat(Proposal.proposalCode, Proposal.proposalNumber).label(
                "parentProposal"
            ),
        )
        .select_from(Proposal)
        .filter(
            Proposal.proposalCode == proposalReference.code,
            Proposal.proposalNumber == proposalReference.number,
        )
        .join(BLSession)
        .filter(BLSession.visit_number == proposalReference.visit_number)
    )

    session = db.session.execute(query).first()

    if session is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Session does not exist"
        )

    return session


def create_data_collection(
    proposalReference: ProposalReference, params: DataCollectionCreationParameters
):
    session_folder, session = _get_folder_and_visit(proposalReference)
    file_directory = f"{session_folder}/{params.fileDirectory}/"
    glob_path = f"GridSquare_*/Data/*{params.fileExtension}"

    _check_raw_files_exist(file_directory, glob_path)

    existing_data_collection = db.session.scalar(
        select(DataCollection.dataCollectionId)
        .filter(
            DataCollection.imageDirectory == file_directory,
            DataCollection.fileTemplate == glob_path,
            DataCollectionGroup.sessionId == session.sessionId,
        )
        .join(DataCollectionGroup)
        .limit(1)
    )

    if existing_data_collection is not None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Data collection already exists",
        )

    dcg_id = db.session.scalar(
        insert(DataCollectionGroup).returning(
            DataCollectionGroup.dataCollectionGroupId
        ),
        {
            "sessionId": session.sessionId,
            "comments": "Created by PATo",
            "experimentType": "EM",
        },
    )

    data_collection = db.session.scalar(
        insert(DataCollection).returning(DataCollection),
        {
            "dataCollectionGroupId": dcg_id,
            "endTime": session.endDate,
            "runStatus": "Created by PATo",
            "imageDirectory": file_directory,
            "fileTemplate": glob_path,
            "imageSuffix": params.fileExtension,
        },
    )

    db.session.commit()

    return data_collection


def check_reprocessing_enabled(proposalReference: ProposalReference):
    end_date = db.session.scalar(
        select(BLSession.endDate)
        .select_from(Proposal)
        .filter(
            Proposal.proposalCode == proposalReference.code,
            Proposal.proposalNumber == proposalReference.number,
            BLSession.visit_number == proposalReference.visit_number,
        )
        .join(BLSession)
    )

    return SessionAllowsReprocessing(
        allowReprocessing=((bool(Config.mq.user)) and check_session_active(end_date)),
    )


def upload_processing_model(file: UploadFile, proposal_reference: ProposalReference):
    file_path = (
        f"{_get_folder_and_visit(proposal_reference)[0]}/processing/{file.filename}"
    )
    file_signature = file.file.read(8)
    file.file.seek(0)

    if file_signature != HDF5_FILE_SIGNATURE:
        raise HTTPException(
            detail="Invalid file type (must be HDF5 file)",
            status_code=status.HTTP_415_UNSUPPORTED_MEDIA_TYPE,
        )

    try:
        with open(file_path, "wb") as f:
            shutil.copyfileobj(file.file, f)
    except OSError as e:
        file.file.close()
        app_logger.error(f"Failed to upload {file.filename}: {e}")
        raise HTTPException(
            detail="Failed to upload file",
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        )

    file.file.close()
