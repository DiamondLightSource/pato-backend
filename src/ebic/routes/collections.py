from fastapi import APIRouter, Depends

from ..auth import Permissions, User
from ..crud import collections as crud
from ..models.response import (
    DataCollectionSummaryOut,
    FullMovie,
    ProcessingJobOut,
    Tomogram,
)
from ..utils.database import Paged
from ..utils.dependencies import pagination

auth = Permissions.collection

router = APIRouter(
    tags=["Data Collections"],
    prefix="/dataCollections",
)


@router.get("", response_model=Paged[DataCollectionSummaryOut])
def get_collections(
    groupId: int = None,
    page: dict[str, int] = Depends(pagination),
    search: str = "",
    onlyTomograms: bool = False,
    user=Depends(User),
):
    """List collections belonging to a data collection group"""
    return crud.get_collections(
        groupId=groupId, search=search, user=user, onlyTomograms=onlyTomograms, **page
    )


@router.get("/{collectionId}/tomogram", response_model=Tomogram)
def get_tomogram(collectionId: int = Depends(auth)):
    """Get tomogram that belongs to the collection"""
    return crud.get_tomogram(collectionId)


@router.get("/{collectionId}/processingJobs", response_model=Paged[ProcessingJobOut])
def get_processing_jobs(
    collectionId: int = Depends(auth),
    page: dict[str, int] = Depends(pagination),
    search: str = "",
):
    """Get processing jobs that belong to the collection"""
    return crud.get_processing_jobs(search=search, collectionId=collectionId, **page)


@router.get("/{collectionId}/motion", response_model=Paged[FullMovie])
def get_motion_correction(
    collectionId: int = Depends(auth),
    page: dict[str, int] = Depends(pagination),
):
    """Get motion correction and tilt alignment data"""
    return crud.get_motion_correction(collectionId=collectionId, **page)
