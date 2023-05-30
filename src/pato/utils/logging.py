import logging

uvicorn_logger = logging.getLogger("uvicorn.access")

logging.basicConfig(format="%(levelname)s: %(message)s")
app_logger = logging.getLogger("uvicorn")
app_logger.setLevel("INFO")


class EndpointFilter(logging.Filter):
    def filter(self, record: logging.LogRecord) -> bool:
        if type(record.args) is not tuple:
            return True

        return not record.args or record.args[2] != "/docs"
