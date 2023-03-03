from pato.auth.template import GenericUser

admin = GenericUser(
    fedid="admin",
    id=00,
    familyName="Admin",
    title="Dr.",
    givenName="McAdmin",
    permissions=[11],
)

em_admin = GenericUser(
    fedid="em_admin",
    id=18660,
    familyName="EM",
    title="Dr.",
    givenName="Admin",
    permissions=[8],
)

user = GenericUser(
    fedid="user",
    id=18600,
    familyName="Generic",
    title="Dr.",
    givenName="User",
    permissions=[],
)

mx_admin = GenericUser(
    fedid="mx_admin",
    id=16000,
    familyName="MX",
    title="Dr.",
    givenName="Admin",
    permissions=[1],
)


class MockResponse:
    def __init__(self, status=200, data={"details": ""}):
        self.status_code = status
        self.data = data

    def json(self):
        return self.data
