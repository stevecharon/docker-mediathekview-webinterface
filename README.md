[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/conrad784/mediathekview-webinterface.svg)](https://hub.docker.com/r/conrad784/mediathekview-webinterface)
[![GitHub-Issues](https://img.shields.io/github/issues/conrad784/docker-mediathekview-webinterface)](https://github.com/conrad784/docker-mediathekview-webinterface/issues)
[![GitHub-Releases](https://img.shields.io/github/tag/conrad784/docker-mediathekview-webinterface.svg)](https://github.com/conrad784/docker-mediathekview-webinterface/releases)

# docker-mediathekview
X11rdp Version of Mediathekview
## About
Using this container allows you to run Mediathekview as a service and control it via webbrowser like Firefox or Chrome.
The X11rdp feature is inherited from [https://github.com/jlesage/docker-baseimage-gui](https://github.com/jlesage/docker-baseimage-gui).

## Installation
### Manual

1. Download Dockerfile or clone the repository.
2. Run `docker build .` to create the docker image.
3. Wait until build process is finished.

### Pre-build
The Github repository is automatically build by Docker Hub.
You can pull it from Docker Hub:
```
docker pull conrad784/mediathekview-webinterface:latest
```
Some older versions can also be acquired by using e.g.
```
docker pull conrad784/mediathekview-webinterface:13.3.0-3
```

## Running it
For additional configuration options, have a look at the [available environment-variables](https://github.com/jlesage/docker-baseimage-gui#environment-variables).
For basic usage, just use
```
docker run -it -p 127.0.0.1:5800:5800 --rm \
    -v $HOME/.mediathek3:/config:rw \
    -v <path to your media files>:/output:rw \
    conrad784/mediathekview-webinterface:latest
```
