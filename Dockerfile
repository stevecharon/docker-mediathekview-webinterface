# Pull base image.
FROM jlesage/baseimage-gui:debian-9

ENV USER_ID=0 GROUP_ID=0 TERM=xterm

ENV MEDIATHEK_VERSION=13.2.1
# Define software download URLs.
ARG MEDIATHEKVIEW_URL=https://download.mediathekview.de/stabil/MediathekView-$MEDIATHEK_VERSION.zip

# Define working directory.
WORKDIR /tmp

# install openjdk creates links in man1...
RUN mkdir -p /usr/share/man/man1

# Install dependencies.
RUN apt-get update
RUN apt-get upgrade -y
# Build deps
RUN apt-get install -y apt-utils unzip locales
RUN echo en_US.UTF-8 UTF-8 > /etc/locale.gen
RUN locale-gen

ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
# Run deps
RUN \
    apt-get install -y \
        wget \
	openjdk-8-jre \
	openjfx \
        ffmpeg \
        vlc \
	flvstreamer

# download Mediathekview
RUN mkdir -p /opt/
RUN wget -q ${MEDIATHEKVIEW_URL} -O /opt/MediathekView.zip
RUN unzip /opt/MediathekView.zip -d /opt/

# Maximize only the main/initial window.
RUN \
    sed-patch 's/<application type="normal">/<application type="normal" title="Mediathekview">/' \
        /etc/xdg/openbox/rc.xml

COPY src/startapp.sh /startapp.sh

# Set environment variables.
ENV APP_NAME="Mediathekview" \
    S6_KILL_GRACETIME=8000

# Define mountable directories.
VOLUME ["/config"]
VOLUME ["/output"]

# Metadata.
LABEL \
      org.label-schema.name="mediathekview" \
      org.label-schema.description="Docker container for Mediathekview" \
      org.label-schema.version="unknown" \
      org.label-schema.vcs-url="https://github.com/conrad784/docker-mediathekview-webinterface" \
      org.label-schema.schema-version="1.0"


ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
