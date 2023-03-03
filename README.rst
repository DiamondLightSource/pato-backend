PATo API
===========================

|code_ci| |coverage| |license|

============== ==============================================================
Source code    https://gitlab.diamond.ac.uk/lims/pato-backend
============== ==============================================================

Particle Analysis and Tomography Data API.

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
3. Run :code:`uvicorn` with `uvicorn pato.main:app --reload --port 8000`

Running Kubernetes deployment for frontend and API:

1. View `PATo Helm <https://gitlab.diamond.ac.uk/lims/pato-helm>`_.

============
Testing
============

- Build the database Docker image in `database` with :code:`podman build . -t diamond-ispyb`
- Run with :code:`podman run -p 3306:3306 --detach --name diamond-ispyb localhost/diamond-ispyb`
    - You may change the port or where the container itself runs, just remember to update `.test.env`
- Run :code:`pytest tests`

.. |code_ci| image:: https://gitlab.diamond.ac.uk/lims/pato-backend/badges/master/pipeline.svg
    :target: https://gitlab.diamond.ac.uk/lims/pato-backend/-/pipelines
    :alt: Code CI

.. |coverage| image:: https://gitlab.diamond.ac.uk/lims/pato-backend/badges/master/coverage.svg
    :target: https://gitlab.diamond.ac.uk/lims/pato-backend/-/pipelines
    :alt: Test Coverage

.. |license| image:: https://img.shields.io/badge/License-Apache%202.0-blue.svg
    :target: https://opensource.org/licenses/Apache-2.0
    :alt: Apache License

..
    Anything below this line is used when viewing README.rst and will be replaced
    when included in index.rst
