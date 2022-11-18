import os

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .routes import auth, image, list, tomogram
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


app.include_router(auth.router)
app.include_router(list.router)
app.include_router(tomogram.router)
app.include_router(image.router)
