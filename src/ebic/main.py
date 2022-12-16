from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .routes import collections, groups, movies, proposals, sessions, tomograms
from .utils.database import get_session

app = FastAPI()

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


app.include_router(sessions.router)
app.include_router(tomograms.router)
app.include_router(movies.router)
app.include_router(collections.router)
app.include_router(groups.router)
app.include_router(proposals.router)
