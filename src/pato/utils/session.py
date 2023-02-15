import os

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from .config import Config

engine = create_engine(
    url=os.environ.get("SQL_DATABASE_URL", "mysql://admin:admin@localhost:8000/ispyb"),
    pool_pre_ping=True,
    pool_recycle=3600,
    pool_size=Config.ispyb.pool,
    max_overflow=Config.ispyb.overflow,
)

_session = sessionmaker(autocommit=False, autoflush=False, bind=engine)
