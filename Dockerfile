# Base image for building Java applications with Oracle JDK.

FROM debian:jessie

MAINTAINER Kay Abendroth "kay.abendroth@raxion.net"

LABEL description="This image is used to provide a lightweight \
    environment for compiling Java 8 source code. It's based on Debian \
    Jessie, the 'stable' version of Debian. The JDK8 packages comes \
    from a Launchpad repo containing the Oracle JDK."
LABEL version="0.3.0"


# Set user and environment variables.
USER root
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Add Launchpad repo.
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu wily main" > /etc/apt/sources.list.d/webupd8team-java-wily.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886

# Refresh line for up-to-date packages.
ENV REFRESH_AT='2016-01-06'

# Update package lists and upgrade all pre-installed packages to their
# latest version.
RUN apt-get -yqq update && apt-get -y upgrade && apt-get -y dist-upgrade

# Set locale.
ENV LANGUAGE en_US.UTF-8
ENV LANG     en_US.UTF-8
ENV LC_ALL   en_US.UTF-8
# We're installing the locales-all package due to
# https://github.com/abevoelker/docker-ubuntu-locale/blob/27b6e5b3adf9192c58f48bc58691c1e84e0c8635/README.md
RUN apt-get -y install locales locales-all
# http://serverfault.com/a/689947
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN echo 'LANG="${LANG}"' > /etc/default/locale
RUN dpkg-reconfigure --frontend=noninteractive locales

# Install Oracle JDK 8.
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --no-install-recommends oracle-java8-installer

# Clean up.
RUN apt-get -y clean && \
    rm -Rf /var/cache/oracle-jdk8-installer

