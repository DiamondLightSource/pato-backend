import os
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.exceptions import HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.gzip import GZipMiddleware
from lims_utils.database import get_session
from lims_utils.logging import log_exception_handler, register_loggers
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

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
from .utils.pika import pika_publisher

engine = create_engine(
    url=os.environ.get("SQL_DATABASE_URL", "mysql://admin:admin@localhost:8000/ispyb"),
    pool_pre_ping=True,
    pool_recycle=3600,
    pool_size=Config.ispyb.pool,
    max_overflow=Config.ispyb.overflow,
)

session_factory = sessionmaker(autocommit=False, autoflush=False, bind=engine)


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
