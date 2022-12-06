from unittest.mock import patch

import pytest
from fastapi.testclient import TestClient

from ebic.auth.micro import oauth2_scheme
from ebic.main import app
from ebic.utils.auth import User

from .users import admin


async def mock_send(_, _1, _2, s):
    await s({"type": "http.response.start", "status": 200, "headers": {}})


class MockResponse:
    def __init__(self, status=200, data={"details": ""}):
        self.status_code = status
        self.data = data

    def json(self):
        return self.data


@pytest.fixture(scope="session")
def client():
    yield TestClient(app)


def empty_method():
    return True


@pytest.fixture(scope="function", params=[admin])
def mock_user(request):
    try:
        old_overrides = app.dependency_overrides[User]
    except KeyError:
        old_overrides = empty_method

    app.dependency_overrides[User] = lambda: request.param
    yield
    app.dependency_overrides[User] = old_overrides


@pytest.fixture(scope="function")
def mock_permissions(request):
    app.dependency_overrides[oauth2_scheme] = lambda: "a"
    with patch(
        "ebic.auth.micro.requests.get", return_value=MockResponse(status=request.param)
    ) as _fixture:
        yield _fixture


@pytest.fixture(scope="function", autouse=True)
def exists_mock():
    with patch("ebic.crud.path.isfile", return_value=True) as _fixture:
        yield _fixture


@pytest.fixture(scope="module", autouse=True)
def file_response_mock():
    with patch("ebic.routes.image.FileResponse.__call__", new=mock_send) as _fixture:
        yield _fixture
