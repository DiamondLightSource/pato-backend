from unittest.mock import patch

import pytest
from fastapi.testclient import TestClient

from ebic.main import app
from ebic.utils.auth import get_user, oauth2_scheme

app.dependency_overrides[oauth2_scheme] = lambda: "aaa"
app.dependency_overrides[get_user] = lambda: {"id": "aaa"}


@pytest.fixture(scope="session")
def client():
    yield TestClient(app)


@pytest.fixture(scope="function", autouse=True)
def exists_mock():
    with patch("ebic.crud.path.isfile", return_value=True) as _fixture:
        yield _fixture
