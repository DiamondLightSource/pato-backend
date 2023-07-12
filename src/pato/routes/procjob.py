from fastapi import APIRouter, Depends

from ..auth import Permissions
from ..crud import procjob as crud

auth = Permissions.processing_job

router = APIRouter(
    tags=["Processing Jobs"],
    prefix="/processingJob",
)


@router.get(
    "/{processingJobId}/parameters",
    response_model=dict[str, str],
)
def initiate_tomogram_reprocessing(
    processingJobId: int = Depends(auth),
):
    """Get processing job parameters"""
    return crud.get_parameters(processingJobId)
