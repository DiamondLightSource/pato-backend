import time

from authlib.jose import JsonWebToken
from authlib.jose.errors import DecodeError
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError
from pydantic import ValidationError

jwt = JsonWebToken("RS256")

reuseable_oauth = OAuth2PasswordBearer(tokenUrl="/login", scheme_name="JWT")

with open("ebic/utils/rsa_private.pem", "r") as f:
    private_key = f.read()

with open("ebic/utils/rsa_public.pem", "r") as f:
    public_key = f.read()

header = {"alg": "RS256"}


def auth_and_generate_token(user: str) -> bytes | None:
    permissions = "all_proposals"

    payload = {
        "iss": "https://diamond.ac.uk",
        "aud": "ebicTestApi",
        "exp": int(time.time()) + 300,
        "iat": int(time.time()),
        "sub": user,
        "perms": permissions,
    }

    return jwt.encode(header, payload, private_key)


def get_user(token: str = Depends(reuseable_oauth)):
    try:
        payload = jwt.decode(token, public_key)
    except (JWTError, ValidationError, DecodeError):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid session. Please authenticate again.",
        )

    return {"user": payload["sub"], "permissions": payload["perms"]}
