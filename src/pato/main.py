from fastapi import FastAPI
from fastapi.exception_handlers import http_exception_handler
from fastapi.exceptions import HTTPException
from fastapi.middleware.cors import CORSMiddleware
from starlette.requests import Request

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
from .utils.logging import EndpointFilter, app_logger, uvicorn_logger
from .utils.pika import pika_publisher

app = FastAPI(version=__version__)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


uvicorn_logger.addFilter(EndpointFilter())


@app.middleware("http")
async def get_session_as_middleware(request, call_next):
    with get_session():
        return await call_next(request)


@app.exception_handler(HTTPException)
async def log_exception_handler(request: Request, exc: HTTPException):
    if exc.status_code != 401:
        user = "Unknown user"
        try:
            user = request.state.__getattr__("user")
        except AttributeError:
            pass
        finally:
            app_logger.warning(
                "%s @ %s: %s",
                user,
                request.url,
                exc.detail,
            )
    return await http_exception_handler(request, exc)


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
