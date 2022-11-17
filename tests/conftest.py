from unittest.mock import patch

import pytest
from fastapi.testclient import TestClient

from ebic.main import app
from ebic.utils.auth import get_user, oauth2_scheme

app.dependency_overrides[oauth2_scheme] = lambda: "aaa"
app.dependency_overrides[get_user] = lambda: {"id": "aaa"}


async def mock_send(_, _1, _2, s):
    await s({"type": "http.response.start", "status": 200, "headers": {}})


@pytest.fixture(scope="session")
def client():
    yield TestClient(app)


@pytest.fixture(scope="function", autouse=True)
def exists_mock():
    with patch("ebic.crud.path.isfile", return_value=True) as _fixture:
        yield _fixture


@pytest.fixture(scope="module", autouse=True)
def file_response_mock():
    with patch("ebic.routes.image.FileResponse.__call__", new=mock_send) as _fixture:
        yield _fixture
