# Pull base image.
FROM jlesage/baseimage-gui:debian-9

ENV USER_ID=0 GROUP_ID=0 TERM=xterm

ENV MEDIATHEK_VERSION=13.3.0

# Define working directory.
WORKDIR /tmp

# Install dependencies.
RUN apt-get update
RUN apt-get upgrade -y
# Build deps
RUN apt-get install -y apt-utils locales
RUN echo en_US.UTF-8 UTF-8 > /etc/locale.gen
RUN locale-gen

ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
# Run deps
RUN \
    apt-get install -y \
        wget \
        ffmpeg \
        vlc \
	flvstreamer


# Define software download URLs.
ARG MEDIATHEKVIEW_URL=https://download.mediathekview.de/stabil/MediathekView-$MEDIATHEK_VERSION-linux.tar.gz
ARG OPENJDK_URL=https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.4%2B11/OpenJDK11U-jdk_x64_linux_hotspot_11.0.4_11.tar.gz

# install openjdk
RUN wget -q ${OPENJDK_URL}
RUN tar xf OpenJDK11U-jdk_x64_linux_hotspot_11.0.4_11.tar.gz -C /opt
ENV JAVA_HOME=/opt/jdk-11.0.4+11

# download Mediathekview
RUN mkdir -p /opt/MediathekView
RUN wget -q ${MEDIATHEKVIEW_URL} -O MediathekView.tar.gz
RUN tar xf MediathekView.tar.gz -C /opt/MediathekView

# Mediathekview 13.3.0 is not runnable as other UID without this hack
# seems like the $HOME variable is not properly read, so set log file manually in call
RUN sed -i -e 's/\-Xmx1G/\-Xmx1G\ \-DmvLogOutputPath\=\$HOME\/mediathekview.log/g' /opt/MediathekView/MediathekView.sh

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
