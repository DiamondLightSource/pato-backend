import pytest
from fastapi.testclient import TestClient

from ebic.main import app
from ebic.utils.auth import get_user, oauth2_scheme

app.dependency_overrides[oauth2_scheme] = lambda: "aaa"


@pytest.fixture(scope="session")
def client(request):
    app.dependency_overrides[get_user] = lambda: {"id": request.param}
    yield TestClient(app)
