import os
from contextlib import asynccontextmanager
from threading import Thread

from fastapi import FastAPI
from fastapi.exceptions import HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.gzip import GZipMiddleware
from lims_utils.database import get_session
from lims_utils.logging import log_exception_handler, register_loggers

from . import __version__
from .routes import (
    autoproc,
    collections,
    feedback,
    foil_holes,
    grid_squares,
    groups,
    movies,
    persons,
    procjob,
    proposals,
    sessions,
    tomograms,
)
from .utils.config import Config
from .utils.database import session_factory
from .utils.pika import start_email_consumer


@asynccontextmanager
async def lifespan(app: FastAPI):
    register_loggers()
    consumer_thread = Thread(target=start_email_consumer)
    consumer_thread.start()
    yield


app = FastAPI(version=__version__, lifespan=lifespan)

api = FastAPI()

if Config.cors:
    api.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

api.add_middleware(GZipMiddleware, minimum_size=1000, compresslevel=5)


@api.middleware("http")
async def get_session_as_middleware(request, call_next):
    with get_session(session_factory):
        return await call_next(request)


api.add_exception_handler(HTTPException, log_exception_handler)

api.include_router(sessions.router)
api.include_router(tomograms.router)
api.include_router(movies.router)
api.include_router(collections.router)
api.include_router(groups.router)
api.include_router(proposals.router)
api.include_router(autoproc.router)
api.include_router(feedback.router)
api.include_router(procjob.router)
api.include_router(grid_squares.router)
api.include_router(foil_holes.router)
api.include_router(persons.router)

app.mount(os.getenv("MOUNT_POINT", "/api"), api)
