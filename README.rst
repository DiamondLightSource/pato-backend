eBIC API
===========================

|code_ci| |docs_ci| |coverage| |pypi_version| |license|

============== ==============================================================
Source code    https://gitlab.diamond.ac.uk/yrh59256/ebic-backend
============== ==============================================================

API for tomogram and miscellaneous information relating to eBIC.

==========
Deployment
==========

Running development server on your machine:

- Install the package with :code:`pip install .` or :code:`pip install -e .`
- Set the `SQL_DATABASE_URL` environment variable according to your database's location
- Run :code:`uvicorn` with `uvicorn ebic.main:app --reload --port 8000`

Running Kubernetes deployment for database and API:

If you configuration is not pointing to a proper repository with the images, you can build the images with `minikube`:

.. code-block:: bash
    $ minikube build . -t ebic:0.0.1
    $ minikube build . -t diamond-ispyb:0.0.1

Create the deployment and nodePort service with :code:`kubectl create -f deployment.yaml`

You should be able to access the service at the IP displayed by the :code:`minikube ip` command, at port :code:`31394` by default. This can be verified by running `curl` and expecting the following response:

.. code-block:: bash
    $ curl $(minikube ip):31394
    {"detail":"Not Found"}

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
