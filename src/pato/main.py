from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.exceptions import HTTPException
from fastapi.middleware.cors import CORSMiddleware
from lims_utils.logging import log_exception_handler, register_loggers

from . import __version__
from .routes import (
    autoproc,
    collections,
    feedback,
    groups,
    movies,
    procjob,
    proposals,
    sessions,
    tomograms,
)
from .utils.config import Config
from .utils.database import get_session
from .utils.pika import pika_publisher


@asynccontextmanager
async def lifespan(app: FastAPI):
    pika_publisher.connect()
    yield


app = FastAPI(version=__version__, lifespan=lifespan)

if Config.cors:
    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

register_loggers()


@app.middleware("http")
async def get_session_as_middleware(request, call_next):
    with get_session():
        return await call_next(request)


app.add_exception_handler(HTTPException, log_exception_handler)


app.include_router(sessions.router)
app.include_router(tomograms.router)
app.include_router(movies.router)
app.include_router(collections.router)
app.include_router(groups.router)
app.include_router(proposals.router)
app.include_router(autoproc.router)
app.include_router(feedback.router)
app.include_router(procjob.router)
