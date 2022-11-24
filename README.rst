eBIC API
===========================

|code_ci| |docs_ci| |coverage| |pypi_version| |license|

============== ==============================================================
Source code    https://gitlab.diamond.ac.uk/yrh59256/ebic-backend
============== ==============================================================

API for tomogram and miscellaneous information relating to eBIC.

==========
Configuration
==========

The API supports a configuration file, that follows the example set in :code:`config.json`, but most importantly, two environment variables need to be set:

- :code:`SQL_DATABASE_URL`: The URL for the database
- :code:`CONFIG_PATH`: Path for the configuration file

==========
Deployment
==========

Running development server on your machine:

1. Install the package with :code:`pip install .` or :code:`pip install -e .`
2. Set the `SQL_DATABASE_URL` environment variable according to your database's location
3. Run :code:`uvicorn` with `uvicorn ebic.main:app --reload --port 8000`

Running Kubernetes deployment for frontend and API:

1. Build and push frontend/backend images to your local repository (remember to change the location in the configuration file).
2. Create a secret (or alter the configuration file) containing the SQL database URL, placing it under the :code:`SQL_DATABASE_URL` environment variable in the Kubernetes deployment section.
3. Apply the changes and create the LoadBalancer service, ingress and pod with :code:`kubectl apply -f deployment.yaml`
4. Access the deployment (in the frontend) through the host provided to the ingress, and communicate with the API through the same host, followed by :code:`/api`

Note: you may need to adapt some deployment configurations for it to work on an environment that differs from the one used here. It is recommended to carefully study all configuration options as they could possibly break your deployment.

============
Testing
============

- Build the database Docker image in `database` with :code:`podman build . -t diamond-ispyb`
- Run with :code:`podman run -p 3306:3306 --detach --name diamond-ispyb localhost/diamond-ispyb`
    - You may change the port or where the container itself runs, just remember to update `.test.env`
- Run :code:`pytest tests`

.. |code_ci| image:: https://github.com/DiamondLightSource/python3-pip-skeleton/actions/workflows/code.yml/badge.svg?branch=main
    :target: https://github.com/DiamondLightSource/python3-pip-skeleton/actions/workflows/code.yml
    :alt: Code CI

.. |docs_ci| image:: https://github.com/DiamondLightSource/python3-pip-skeleton/actions/workflows/docs.yml/badge.svg?branch=main
    :target: https://github.com/DiamondLightSource/python3-pip-skeleton/actions/workflows/docs.yml
    :alt: Docs CI

.. |coverage| image:: https://codecov.io/gh/DiamondLightSource/python3-pip-skeleton/branch/main/graph/badge.svg
    :target: https://codecov.io/gh/DiamondLightSource/python3-pip-skeleton
    :alt: Test Coverage

.. |pypi_version| image:: https://img.shields.io/pypi/v/python3-pip-skeleton.svg
    :target: https://pypi.org/project/python3-pip-skeleton
    :alt: Latest PyPI version

.. |license| image:: https://img.shields.io/badge/License-Apache%202.0-blue.svg
    :target: https://opensource.org/licenses/Apache-2.0
    :alt: Apache License

..
    Anything below this line is used when viewing README.rst and will be replaced
    when included in index.rst
