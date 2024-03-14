from unittest.mock import MagicMock, patch

import pytest
from fastapi.security import HTTPAuthorizationCredentials
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from pato.auth import User
from pato.auth.micro import oauth2_scheme
from pato.main import app
from pato.utils.database import db

from .users import admin

engine = create_engine(
    url="mysql://root:ispyb-root@127.0.0.1/ispyb",
    pool_pre_ping=True,
    pool_recycle=3600,
    pool_size=3,
    max_overflow=5,
)

Session = sessionmaker()
app.user_middleware.clear()
app.middleware_stack = app.build_middleware_stack()


async def mock_send(_, _1, _2, s):
    await s({"type": "http.response.start", "status": 200, "headers": {}})


@pytest.fixture(scope="function", autouse=True)
def mock_config():
    with patch(
        "pato.utils.config._read_config", return_value={"auth": "this"}
    ) as _fixture:
        yield _fixture


class MockResponse:
    def __init__(self, status=200, data={"details": ""}):
        self.status_code = status
        self.data = data

    def json(self):
        return self.data


def new_perms(item_id, _, _0):
    return item_id


@pytest.fixture(scope="function")
def client():
    client = TestClient(app)
    conn = engine.connect()
    transaction = conn.begin()
    session = Session(bind=conn, join_transaction_mode="create_savepoint")

    db.set_session(session)

    yield client

    transaction.rollback()
    conn.close()


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


class NewPika:
    def __init__(self):
        self.publish = MagicMock()


@pytest.fixture(scope="session", autouse=True)
def mock_pika():
    with patch("pato.crud.collections.pika_publisher", new=NewPika()) as _fixture:
        yield _fixture


@pytest.fixture(scope="function")
def mock_permissions(request):
    app.dependency_overrides[oauth2_scheme] = lambda: HTTPAuthorizationCredentials(
        credentials="a", scheme="Bearer"
    )
    with patch("pato.auth.micro._check_perms", new=new_perms) as _fixture:
        yield _fixture


@pytest.fixture(scope="function", autouse=True)
def exists_mock():
    with patch("pato.utils.generic.isfile", return_value=True) as _fixture:
        yield _fixture
