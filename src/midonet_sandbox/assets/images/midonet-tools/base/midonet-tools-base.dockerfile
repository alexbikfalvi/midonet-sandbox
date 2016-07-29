FROM ubuntu-upstart:14.04
MAINTAINER MidoNet (http://midonet.org)

ONBUILD ADD conf/midonet.list /etc/apt/sources.list.d/midonet.list
ONBUILD ADD bin/run-midonettools.sh /run-midonettools.sh

ONBUILD RUN curl -k http://repo.midonet.org/packages.midokura.key | apt-key add -
ONBUILD RUN curl -k http://builds.midonet.org/midorepo.key | apt-key add -
ONBUILD RUN apt-get -qy update

RUN apt-get -qy update

# Install Java 8
RUN apt-get install -qy software-properties-common
RUN add-apt-repository -y ppa:openjdk-r/ppa
RUN apt-get update && apt-get install -qy openjdk-8-jdk --no-install-recommends
RUN apt-get update && apt-get install -qy curl && apt-get install -qy git uuid

CMD ["/run-midonettools.sh"]