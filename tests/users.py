from ebic.auth.template import GenericUser

admin = GenericUser(
    fedid="admin",
    id=00,
    family_name="Admin",
    title="Dr.",
    given_name="McAdmin",
    permissions=[11],
)

em_admin = GenericUser(
    fedid="em_admin",
    id=18660,
    family_name="EM",
    title="Dr.",
    given_name="Admin",
    permissions=[8],
)

user = GenericUser(
    fedid="user",
    id=18600,
    family_name="Generic",
    title="Dr.",
    given_name="User",
    permissions=[],
)


class MockResponse:
    def __init__(self, status=200, data={"details": ""}):
        self.status_code = status
        self.data = data

    def json(self):
        return self.data
