from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from . import __version__
from .routes import (
    autoproc,
    collections,
    groups,
    movies,
    proposals,
    sessions,
    tomograms,
)
from .utils.database import get_session
from .utils.pika import pika_publisher

app = FastAPI(version=__version__)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.middleware("http")
async def get_session_as_middleware(request, call_next):
    with get_session():
        return await call_next(request)


@app.on_event("startup")
async def startup():
    pika_publisher.connect()


app.include_router(sessions.router)
app.include_router(tomograms.router)
app.include_router(movies.router)
app.include_router(collections.router)
app.include_router(groups.router)
app.include_router(proposals.router)
app.include_router(autoproc.router)
