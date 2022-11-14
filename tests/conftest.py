import pytest
from fastapi.testclient import TestClient

from ebic.main import app
from ebic.utils.auth import get_user


def override_get_user():
    return {"user": "lauda"}


app.dependency_overrides[get_user] = override_get_user


@pytest.fixture(scope="session")
def client():
    yield TestClient(app)
