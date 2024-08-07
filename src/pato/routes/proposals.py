from fastapi import APIRouter, Body, Depends, status
from fastapi.responses import RedirectResponse
from lims_utils.models import Paged, pagination

from ..auth import Permissions, User
from ..crud import proposals as crud
from ..crud import sessions as sessions_crud
from ..models.parameters import DataCollectionCreationParameters
from ..models.response import (
    BaseDataCollectionOut,
    ProposalResponse,
    SessionAllowsReprocessing,
    SessionResponse,
)
from ..utils.config import Config

router = APIRouter(
    tags=["Proposals"],
    prefix="/proposals",
)


@router.get("", response_model=Paged[ProposalResponse])
def get_proposals(
    page: dict[str, int] = Depends(pagination), search: str = "", user=Depends(User)
):
    """List proposals"""
    return crud.get_proposals(search=search, user=user, **page)


@router.get(
    "/{proposalReference}/sessions/{visitNumber}",
    response_model=SessionResponse,
    tags=["Sessions"],
)
def get_session(proposalReference=Depends(Permissions.session)):
    """Get individual session"""
    return sessions_crud.get_session(proposalReference)


@router.post(
    "/{proposalReference}/sessions/{visitNumber}/dataCollections",
    response_model=BaseDataCollectionOut,
    status_code=status.HTTP_201_CREATED,
)
def create_data_collection(
    proposalReference=Depends(Permissions.session),
    parameters: DataCollectionCreationParameters = Body(),
):
    """Create data collection"""
    return sessions_crud.create_data_collection(proposalReference, parameters)


@router.get(
    "/{proposalReference}/sessions/{visitNumber}/reprocessingEnabled",
    response_model=SessionAllowsReprocessing,
)
def check_reprocessing_enabled(proposalReference=Depends(Permissions.session)):
    """Check if reprocessing is enabled for session"""
    return sessions_crud.check_reprocessing_enabled(proposalReference)

@router.get(
    "/{proposalReference}/sessions/{visitNumber}/sampleHandling",
    response_class=RedirectResponse,
)
def redirect_to_sample_handling(proposalReference: str, visitNumber: int):
    """Sample handling redirect"""
    suffix = f"/proposals/{proposalReference}/sessions/{visitNumber}"
    return Config.facility.sample_handling_url + suffix
