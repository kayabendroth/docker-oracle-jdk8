# Base image for building Java applications with Oracle JDK.

FROM debian:jessie

MAINTAINER Kay Abendroth "kay.abendroth@raxion.net"

LABEL description="This image is used to provide a lightweight \
    environment for compiling Java 8 source code. It's based on Debian \
    Jessie, the 'stable' version of Debian. The JDK8 packages comes \
    from a Launchpad repo containing the Oracle JDK."
LABEL version="0.2.0"


# Set user and environment variables.
USER root
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Add Launchpad repo.
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu vivid main" > /etc/apt/sources.list.d/webupd8team-java-vivid.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886

# Refresh line for up-to-date packages.
ENV REFRESH_AT='2015-08-05'

# Update package lists and upgrade all pre-installed packages to their
# latest version.
RUN apt-get -yqq update && apt-get -y upgrade && apt-get -y dist-upgrade

# UTF-8.
RUN apt-get -y install locales
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

# Install Oracle JDK 8.
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --no-install-recommends oracle-java8-installer

# Clean up.
RUN apt-get -y clean && \
    rm -Rf /var/cache/oracle-jdk8-installer

