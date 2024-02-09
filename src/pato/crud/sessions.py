import pathlib
from datetime import datetime
from typing import Optional

from fastapi import HTTPException, status
from lims_utils.models import Paged
from lims_utils.tables import BLSession, DataCollection, DataCollectionGroup, Proposal
from sqlalchemy import Label, and_, extract, func, insert, or_, select

from ..auth import User
from ..models.parameters import DataCollectionCreationParameters
from ..models.response import SessionResponse
from ..utils.auth import check_session
from ..utils.database import db, fast_count, paginate, unravel
from ..utils.generic import ProposalReference, check_session_active, parse_proposal


def _validate_session_active(proposalReference: ProposalReference):
    """Check if session is active and return session ID"""
    session = db.session.scalar(
        select(BLSession)
        .select_from(Proposal)
        .join(BLSession)
        .filter(
            BLSession.visit_number == proposalReference.visit_number,
            Proposal.proposalNumber == proposalReference.number,
            Proposal.proposalCode == proposalReference.code,
        )
    )

    if not check_session_active(session.endDate):
        raise HTTPException(
            status_code=status.HTTP_423_LOCKED,
            detail="Reprocessing cannot be fired on an inactive session",
        )

    return session.sessionId


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
    user: User,
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
            func.count(DataCollectionGroup.dataCollectionGroupId).label(
                "collectionGroups"
            )
        )

    query = select(*unravel(BLSession), *fields)

    if proposal is not None:
        proposal_reference = parse_proposal(proposal)
        query = (
            query.select_from(Proposal)
            .filter(
                and_(
                    Proposal.proposalCode == proposal_reference.code,
                    Proposal.proposalNumber == proposal_reference.number,
                )
            )
            .join(BLSession)
            .order_by(BLSession.visit_number)
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

    if search is not None:
        query = query.filter(
            or_(
                BLSession.beamLineName.contains(search),
                BLSession.visit_number.contains(search),
            )
        )

    query = check_session(query, user)

    total = fast_count(query)

    if countCollections:
        query = query.join(DataCollectionGroup, isouter=True).group_by(
            BLSession.visit_number, BLSession.proposalId
        )

    return paginate(query, limit, page, precounted_total=total)


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
    session_id = _validate_session_active(proposalReference)

    session = db.session.execute(
        select(
            BLSession.beamLineName,
            BLSession.endDate,
            extract("year", BLSession.startDate).label("year"),
            func.concat(
                Proposal.proposalCode,
                Proposal.proposalNumber,
                "-",
                BLSession.visit_number,
            ).label("name"),
        )
        .filter(BLSession.sessionId == session_id)
        .join(Proposal, Proposal.proposalId == BLSession.proposalId)
    ).one()

    # TODO: Make the path string pattern configurable?
    file_directory = f"/dls/{session.beamLineName}/data/{session.year}/{session.name}/{params.fileDirectory}/"
    glob_path = f"GridSquare_*/Data/*{params.fileExtension}"

    _check_raw_files_exist(file_directory, glob_path)

    existing_data_collection = db.session.scalar(
        select(DataCollection.dataCollectionId)
        .filter(
            DataCollection.imageDirectory == file_directory,
            DataCollection.fileTemplate == glob_path,
            DataCollectionGroup.sessionId == session_id,
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
            "sessionId": session_id,
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
