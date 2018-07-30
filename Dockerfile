FROM ubuntu:16.04
MAINTAINER Mario Cho <hephaex@gmail.com>

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository cloud-archive:liberty && \
    apt-get update  && \
    apt-get install -y supervisor swift python-swiftclient rsync \
                       swift-proxy swift-object memcached python-keystoneclient \
                       python-swiftclient swift-plugin-s3 python-netifaces \
                       python-xattr python-memcache \
                       swift-account swift-container swift-object pwgen

RUN mkdir -p /var/log/supervisor
ADD files/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Swift configuration
# - Partially fom http://docs.openstack.org/developer/swift/development_saio.html
ADD conf/dispersion.conf /etc/swift/dispersion.conf
ADD conf/rsyncd.conf /etc/rsyncd.conf
ADD conf/swift.conf /etc/swift/swift.conf
ADD conf/proxy-server.conf /etc/swift/proxy-server.conf
ADD conf/account-server.conf /etc/swift/account-server.conf
ADD conf/object-server.conf /etc/swift/object-server.conf
ADD conf/container-server.conf /etc/swift/container-server.conf
ADD conf/startmain.sh /usr/local/bin/startmain.sh
RUN chmod 755 /usr/local/bin/start.sh

# Swift port
EXPOSE 8080

# Execution Command
CMD /usr/local/bin/start.sh