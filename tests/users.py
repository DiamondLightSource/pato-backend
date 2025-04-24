from lims_utils.auth import GenericUser

admin = GenericUser(
    fedid="admin",
    id=00,
    familyName="Admin",
    title="Dr.",
    givenName="McAdmin",
    permissions=["super_admin"],
    email="admin@diamond.ac.uk",
)

em_admin = GenericUser(
    fedid="em_admin",
    id=18660,
    familyName="EM",
    title="Dr.",
    givenName="Admin",
    permissions=["em_admin"],
    email="em-admin@diamond.ac.uk",
)

user = GenericUser(
    fedid="user",
    id=18600,
    familyName="Generic",
    title="Dr.",
    givenName="User",
    permissions=[],
    email="user@diamond.ac.uk",
)

industrial_user = GenericUser(
    fedid="industrial",
    id=46435,
    familyName="Industrial",
    title="Dr.",
    givenName="User",
    permissions=[],
    email="industrial-user@diamond.ac.uk",
)

mx_admin = GenericUser(
    fedid="mx_admin",
    id=16000,
    familyName="MX",
    title="Dr.",
    givenName="Admin",
    permissions=["mx_admin"],
    email="mx-admin@diamond.ac.uk",
)


class MockResponse:
    def __init__(self, status=200, data={"details": ""}):
        self.status_code = status
        self.data = data

    def json(self):
        return self.data
