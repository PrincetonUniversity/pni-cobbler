# vim: ft=dockerfile

FROM centos:8 AS builder

RUN dnf -y install dnf-plugins-core && \
    dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \               
    dnf -y config-manager --set-enabled powertools

RUN yum install -y          \
# Dev dependencies
    git rsync make dnf-plugins-core     \
    epel-rpm-macros openssl mod_ssl  \
    python3-coverage python3-devel python3-distro python3-cheetah python3-future \
    python3-setuptools python3-requests rpm-build \
    python3-mod_wsgi python3-wheel python3-pip python3-sphinx \
    python3-coverage python3-distro python3-netaddr && \
    pip3 install coverage

RUN yum install -y          \
# Runtime dependencies
    httpd python3-mod_wsgi python3-pymongo python3-PyYAML         \
    python3-netaddr \
    python3-dns        \
    createrepo_c xorriso grub2-efi-ia32-modules grub2-efi-x64-modules   \
    logrotate syslinux systemd-sysv tftp-server fence-agents

## subfolder 'cobbler' is git clone of cobbler sourcecode.
COPY ./cobbler /usr/src/cobbler
WORKDIR /usr/src/cobbler

#VOLUME /usr/src/cobbler/rpm-build

RUN /bin/bash -c "make rpms" && ls -ltha /usr/src/cobbler/rpm-build




FROM centos:8

LABEL MAINTAINER="gmcgrath@princeton.edu<Garrett McGrath>"

## we need epel for the cobblerd service
RUN dnf -y install dnf-plugins-core && \
    dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \               
    dnf -y config-manager --set-enabled powertools

## we'll be using tftp-server instead of xinet.d to handle those responsibilities. epel provides cobbler and mod_auth_cas

RUN yum install -y          \
# Runtime dependencies
    httpd python3-mod_wsgi python3-pymongo python3-PyYAML         \
    python3-netaddr python3-simplejson python3-tornado        \
    python3-django python3-dns python3-ldap3 python3-cheetah python3-sphinx       \
    createrepo_c xorriso grub2-efi-ia32-modules grub2-efi-x64-modules   \
    logrotate syslinux systemd-sysv tftp-server fence-agents

## secondary deps
RUN yum -y install pykickstart tftp gettext augeas supervisor \
    p7zip p7zip-plugins wget curl python3-mod_wsgi && yum clean all \
    && mkdir -p /opt/cobbler-rpms/

## pull rpms from build step above.
COPY --from=0 /usr/src/cobbler/rpm-build /opt/cobbler-rpms

RUN ls -ltha /opt/cobbler-rpms/ && yum -y install /opt/cobbler-rpms/*.noarch.rpm

COPY ./apache/cobbler_web.conf.template ./apache/cas.conf.template /etc/httpd/conf.d/

COPY ./cobblerd/augeas-modifications.augfile.template /opt/

COPY ./cobblerd/users.conf.template /etc/cobbler/users.conf.template
### Augeus config changes.
COPY docker-entrypoint.sh /opt/docker-entrypoint.sh

RUN mkdir -p /etc/supervisord/conf.d

COPY ./supervisord/supervisord.conf /etc/supervisord.conf

COPY ./supervisord/conf.d /etc/supervisord/conf.d

RUN chmod +x /opt/docker-entrypoint.sh

## remote access to this host will be handled via traefik
# EXPOSE 69
# EXPOSE 80


CMD ["/opt/docker-entrypoint.sh"]

COPY ./centos8-cobblerd-source.Dockerfile /centos8-cobblerd-source.Dockerfile
