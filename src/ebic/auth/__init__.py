# flake8: noqa F401
from ..utils.config import Config

auth_type = Config.get()["auth"]["type"].lower()

if auth_type == "micro":
    from ..auth.micro import Permissions, User
elif auth_type == "dummy":
    from ..auth.template import GenericPermissions as Permissions
    from ..auth.template import GenericUser as User
elif auth_type == "oidc":
    from ..auth.oidc import Permissions, User
