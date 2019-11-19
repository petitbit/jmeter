# jmeter-docker
## Image on Docker Hub

Docker image for [Apache JMeter](http://jmeter.apache.org).
This Docker image can be run as the ``jmeter`` command. 
Find Images of this repo on [Docker Hub](https://hub.docker.com/r/petitbit/jmeter).

## Building

The Docker image can be build
from the [Dockerfile](alpine/Dockerfile) but this is not really necessary as
you may use your own ``docker build`` commandline. Or better: use one
of the pre-built Images from [Docker Hub](https://hub.docker.com/r/petitbit/jmeter).

### Build Options

Build argumments with default values if not passed to build:

- **JMETER_VERSION** - JMeter version, default ``4.0``
- **IMAGE_TIMEZONE** - timezone of Docker image, default ``"Asia/Tokyo"``

## Running

The Docker image will accept the same parameters as ``jmeter`` itself, assuming
you run JMeter non-GUI with ``-n``.
