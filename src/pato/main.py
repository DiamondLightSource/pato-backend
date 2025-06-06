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

if Config.cors:
    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

app.add_middleware(GZipMiddleware, minimum_size=1000, compresslevel=5)


@app.middleware("http")
async def get_session_as_middleware(request, call_next):
    with get_session(session_factory):
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
app.include_router(grid_squares.router)
app.include_router(foil_holes.router)
app.include_router(persons.router)
