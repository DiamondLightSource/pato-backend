from fastapi import APIRouter, Body, Depends, status
from lims_utils.models import Paged, pagination

from ..auth import Permissions
from ..crud import collections as crud
from ..crud import generic
from ..models.parameters import (
    SPAReprocessingParameters,
    TomogramReprocessingParameters,
)
from ..models.response import (
    DataPoint,
    FullMovie,
    ItemList,
    ProcessingJobResponse,
    ReprocessingResponse,
    TomogramFullResponse,
)

auth = Permissions.collection

router = APIRouter(
    tags=["Data Collections"],
    prefix="/dataCollections",
)


@router.get("/{collectionId}/tomograms", response_model=Paged[TomogramFullResponse])
def get_tomograms(
    collectionId: int = Depends(auth), page: dict[str, int] = Depends(pagination)
):
    """Get tomogram that belongs to the collection"""
    return crud.get_tomograms(collectionId=collectionId, **page)


@router.post(
    "/{collectionId}/reprocessing/tomograms",
    response_model=ReprocessingResponse,
    status_code=status.HTTP_202_ACCEPTED,
)
def initiate_tomogram_reprocessing(
    parameters: TomogramReprocessingParameters = Body(),
    collectionId: int = Depends(auth),
):
    """Initiate data reprocessing"""
    return crud.initiate_reprocessing_tomogram(parameters, collectionId)


@router.post(
    "/{collectionId}/reprocessing/spa",
    response_model=ReprocessingResponse,
    status_code=status.HTTP_202_ACCEPTED,
)
def initiate_spa_reprocessing(
    parameters: SPAReprocessingParameters = Body(), collectionId: int = Depends(auth)
):
    """Initiate data reprocessing"""
    return crud.initiate_reprocessing_spa(parameters, collectionId)


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
def get_ice_histogram(
    dataBin: float = 10000, minimum: float = 0, collectionId: int = Depends(auth)
):
    """Get relative ice thickness histogram"""
    return generic.get_ice_histogram(
        parent_type="dataCollection",
        parent_id=collectionId,
        minimum=minimum,
        dataBin=dataBin,
    )


@router.get(
    "/{collectionId}/totalMotion",
)
def get_motion_histogram(
    dataBin: float = 50, minimum: float = 0, collectionId: int = Depends(auth)
):
    """Get total motion histogram"""
    return generic.get_motion(
        parent_type="dataCollection",
        parent_id=collectionId,
        minimum=minimum,
        dataBin=dataBin,
    )


@router.get(
    "/{collectionId}/resolution",
)
def get_resolution(
    dataBin: float = 1, minimum: float = 0, collectionId: int = Depends(auth)
):
    """Get estimated resolution histogram"""
    return generic.get_resolution(
        parent_type="dataCollection",
        parent_id=collectionId,
        minimum=minimum,
        dataBin=dataBin,
    )


@router.get(
    "/{collectionId}/particles",
)
def get_particle_count(
    dataBin: float = 50, minimum: float = 0, collectionId: int = Depends(auth)
):
    """Get particle count histogram"""
    return generic.get_particle_count(
        parent_type="dataCollection",
        parent_id=collectionId,
        minimum=minimum,
        dataBin=dataBin,
    )


@router.get(
    "/{collectionId}/ctf",
    description="Get defocus/particle count information",
    response_model=ItemList[DataPoint],
)
def get_ctf(collectionId: int = Depends(auth)):
    return crud.get_ctf(collectionId)


@router.get(
    "/{collectionId}/particleCountPerResolution", response_model=ItemList[DataPoint]
)
def get_particle_count_per_resolution(collectionId: int = Depends(auth)):
    return crud.get_particle_count_per_resolution(collectionId)
