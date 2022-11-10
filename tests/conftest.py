import os

import pytest
from fastapi.testclient import TestClient

from ebic.main import app


@pytest.fixture(scope="session")
def client():
    os.environ["SQL_DATABASE_URL"] = "aaaaa"
    yield TestClient(app)
