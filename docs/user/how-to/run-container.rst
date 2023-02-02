Run in a container
==================

Pre-built containers with pato_backend and its dependencies already
installed are available on `Github Container Registry
<https://ghcr.io/DiamondLightSource/pato_backend>`_.

Starting the container
----------------------

To pull the container from github container registry and run::

    $ docker run ghcr.io/DiamondLightSource/pato_backend:main --version

To get a released version, use a numbered release instead of ``main``.
