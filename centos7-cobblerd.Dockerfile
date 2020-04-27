FROM centos:7

MAINTAINER gmcgrath@princeton.edu<Garrett McGrath>

## as this is a systemd based container a different stop signal is required
# STOPSIGNAL SIGRTMIN+3

## Lifted from the centos docker container documentation: https://hub.docker.com/_/centos/
# ENV container docker
# RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
# systemd-tmpfiles-setup.service ] || rm -f $i; done); \
# rm -f /lib/systemd/system/multi-user.target.wants/*;\
# rm -f /etc/systemd/system/*.wants/*;\
# rm -f /lib/systemd/system/local-fs.target.wants/*; \
# rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
# rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
# rm -f /lib/systemd/system/basic.target.wants/*;\
# rm -f /lib/systemd/system/anaconda.target.wants/*;
# VOLUME [ "/sys/fs/cgroup" ]



## we need epel for the cobblerd service
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum -y install epel-release

## we'll be using tftp-server instead of xinet.d to handle those responsibilities. epel provides cobbler and mod_auth_cas

RUN yum -y install cobbler cobbler-web syslinux pykickstart \
    tftp-server tftp gettext httpd mod_auth_cas augeas supervisor \
    && yum clean all

# RUN systemctl enable httpd \
#     && systemctl enable cobblerd \
#     && systemctl enable tftp

# ## silly hack to make apache write logs to std out.
# RUN ln -sf /proc/self/fd/1 /var/log/httpd/access.log && \
#     ln -sf /proc/self/fd/1 /var/log/httpd/error.log


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
EXPOSE 69
EXPOSE 80


CMD ["/opt/docker-entrypoint.sh"]
