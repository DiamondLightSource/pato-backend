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

Additionally, the following environment variables can be set to enable message queue support:

- :code:`MQ_USER`: Message queue user
- :code:`MQ_PASS`: Message queue password

As for the JSON configuration file, details are as follows:

- auth
    - endpoint: URL for the chosen auth method
    - read_all_perms: Permission groups that should be granted full read permissions
    - type: Authentication type. Can be :code:`micro` or :code:`dummy`
    - beamline_mapping: A map of permission groups and the beamlines that permission group should be allowed to viewing
- mq
    - host: Message queue host
    - port: Mesasge queue port 
    - queue: Queue name
    - vhost: Message queue virtual host
- ispyb
    - pool: Connection pool size
    - overflow: Connection pool overflow max size
- facility
    - contact_email: Contact email to be used across the application
    - smtp_server: SMTP server host
    - smtp_port: SMTP port to be used for emailing reports
    - active_session_cutoff: Time, in weeks, to be used as a threshold for determining if a session is active or not, following the end of the first processing pipeline. For example, a session would be considered inactive if there were no new actions for the past 5 weeks, by default.

==========
Deployment
==========

Running development server on your machine:

1. Install the package with :code:`pip install .` or :code:`pip install -e .`
2. Set the `SQL_DATABASE_URL` environment variable according to your database's location
3. Run :code:`uvicorn` with `uvicorn pato.main:app --reload --port 8000 --host 0.0.0.0`

Running Kubernetes deployment for frontend and API:

1. View `PATo Helm <https://gitlab.diamond.ac.uk/lims/pato-helm>`_.

Optional dependencies:

You might want to test out RabbitMQ integration. In order to do that, you need to point to a valid MQ instance. You can run one locally with :code:`podman run -d -e RABBITMQ_DEFAULT_USER=guest -e RABBITMQ_DEFAULT_PASS=guest -p 5672:5672 rabbitmq:3`

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
