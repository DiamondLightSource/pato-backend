from fastapi import APIRouter, Body, Depends

from ..auth import Permissions
from ..crud import collections as crud
from ..crud.generic import get_ice_histogram_generic
from ..models.parameters import ReprocessingParameters
from ..models.response import FullMovie, ProcessingJobResponse, TomogramResponse
from ..utils.database import Paged
from ..utils.dependencies import pagination

auth = Permissions.collection

router = APIRouter(
    tags=["Data Collections"],
    prefix="/dataCollections",
)


@router.get("/{collectionId}/tomograms", response_model=Paged[TomogramResponse])
def get_tomograms(
    collectionId: int = Depends(auth), page: dict[str, int] = Depends(pagination)
):
    """Get tomogram that belongs to the collection"""
    return crud.get_tomograms(collectionId=collectionId, **page)


@router.post("/{collectionId}/tomograms/reprocessing")
def initiate_reprocessing(
    parameters: ReprocessingParameters = Body(), collectionId: int = Depends(auth)
):
    """Initiate data reprocessing"""
    return crud.initiate_reprocessing(parameters, collectionId)


@router.get(
    "/{collectionId}/processingJobs", response_model=Paged[ProcessingJobResponse]
)
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


@router.get(
    "/{collectionId}/iceThickness",
)
def get_ice_histogram(dataBin: float = 10000, collectionId: int = Depends(auth)):
    """Get relative ice thickness histogram"""
    return get_ice_histogram_generic(
        parent_type="dataCollection", parent_id=collectionId, dataBin=dataBin
    )
