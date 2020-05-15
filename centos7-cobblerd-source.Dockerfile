# vim: ft=dockerfile

FROM centos:7 AS builder

RUN yum makecache fast && \
    yum install -y epel-release && \
    yum install -y https://repo.ius.io/ius-release-el7.rpm \
                   https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum makecache fast

RUN yum install -y          \
# Dev dependencies
    git rsync make dnf-plugins-core     \
    epel-rpm-macros openssl mod_ssl python-sphinx   \
    python36-coverage python36-devel python36-distro         \
    python36-future python36-pyflakes python36-pycodestyle    \
    python36-setuptools python36-requests python36-sphinx rpm-build \
    python36-mod_wsgi

RUN yum install -y          \
# Runtime dependencies
    httpd python36-mod_wsgi python36-pymongo python36-PyYAML         \
    python36-netaddr python36-simplejson python36-tornado        \
    python36-django python36-dns python36-ldap3 python36-cheetah        \
    createrepo_c xorriso grub2-efi-ia32-modules grub2-efi-x64-modules   \
    logrotate syslinux systemd-sysv tftp-server fence-agents

## subfolder 'cobbler' is git clone of cobbler sourcecode.
COPY ./cobbler /usr/src/cobbler
WORKDIR /usr/src/cobbler

#VOLUME /usr/src/cobbler/rpm-build

RUN /bin/bash -c "make rpms" && ls -ltha /usr/src/cobbler/rpm-build




FROM centos:7

MAINTAINER gmcgrath@princeton.edu<Garrett McGrath>

## we need epel for the cobblerd service
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum -y install epel-release

## we'll be using tftp-server instead of xinet.d to handle those responsibilities. epel provides cobbler and mod_auth_cas

RUN yum install -y          \
# Runtime dependencies
    httpd python36-mod_wsgi python36-pymongo python36-PyYAML         \
    python36-netaddr python36-simplejson python36-tornado        \
    python36-django python36-dns python36-ldap3 python36-cheetah        \
    createrepo_c xorriso grub2-efi-ia32-modules grub2-efi-x64-modules   \
    logrotate syslinux systemd-sysv tftp-server fence-agents

## secondary deps
RUN yum -y install pykickstart tftp gettext mod_auth_cas augeas supervisor \
    p7zip p7zip-plugins wget curl python36-mod_wsgi && yum clean all \
    && mkdir -p /opt/cobbler-rpms/

## pull rpms from build step above.
COPY --from=0 /usr/src/cobbler/rpm-build /opt/cobbler-rpms

RUN ls -ltha /opt/cobbler-rpms/ && yum -y install /opt/cobbler-rpms/*

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
