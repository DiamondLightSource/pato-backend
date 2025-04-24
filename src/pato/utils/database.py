import os

from lims_utils.database import Database
from lims_utils.tables import Base
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from .config import Config

db = Database()

engine = create_engine(
    url=os.environ.get("SQL_DATABASE_URL", "mysql://admin:admin@localhost:8000/ispyb"),
    pool_pre_ping=True,
    pool_recycle=3600,
    pool_size=Config.ispyb.pool,
    max_overflow=Config.ispyb.overflow,
)

session_factory = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def unravel(model: Base):
    return list(model.__table__.columns)
