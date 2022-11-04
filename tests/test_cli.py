import subprocess
import sys

from ebic_backend import __version__


def test_cli_version():
    cmd = [sys.executable, "-m", "ebic_backend", "--version"]
    assert subprocess.check_output(cmd).decode().strip() == __version__
