# vim: ft=dockerfile
FROM quay.io/centos/centos:stream9

LABEL MAINTAINER="gmcgrath@princeton.edu<Garrett McGrath>"

## we need epel for the cobblerd service
RUN dnf -y install dnf-plugins-core && \
    dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm

RUN dnf install -y http://springdale.princeton.edu/data/springdale/unsupported/9.1/x86_64/cobbler-3.3.3-2.sdl9.3.noarch.rpm \
http://springdale.princeton.edu/data/springdale/unsupported/9.1/x86_64/cobbler-tests-3.3.3-2.sdl9.3.noarch.rpm

## we'll be using tftp-server instead of xinet.d to handle those responsibilities. epel provides cobbler and mod_auth_cas

## install grub deps.
RUN dnf install -y grub2-efi-aa64-modules grub2-efi-x64-cdboot grub2-efi-x64-modules \
  grub2-pc grub2-pc-modules grub2-tools-efi grub2-tools-extra

#RUN yum install -y cobbler cobbler-tests

## secondary deps
RUN dnf -y install less pykickstart tftp augeas supervisor syslinux \
    shim-x64 shim-ia32 grub2-efi-x64 ipxe-bootimgs ipxe-bootimgs-aarch64 \
    p7zip p7zip-plugins python3-pip dnf-plugins-core && dnf clean all 
#    && cp -v /boot/efi/EFI/centos/*.efi /var/lib/cobbler/loaders/ 

RUN pip3 install bios

## pull rpms from build step above.
#COPY ./apache/cobbler_web.conf.template ./apache/cas.conf.template /etc/httpd/conf.d/

COPY ./cobblerd/augeas-modifications.augfile.template /opt/

COPY ./cobblerd/settings-modified.yaml /etc/cobbler/settings.yaml

#COPY ./cobblerd/users.conf.template /etc/cobbler/users.conf.template

### Augeus config changes.
COPY docker-entrypoint.sh /opt/docker-entrypoint.sh

RUN mkdir -p /etc/supervisord/conf.d

COPY ./supervisord/supervisord.conf /etc/supervisord.conf

COPY ./supervisord/conf.d /etc/supervisord/conf.d

RUN chmod +x /opt/docker-entrypoint.sh

CMD ["/opt/docker-entrypoint.sh"]

COPY ./centos9-cobblerd-source.Dockerfile /centos9-cobblerd-source.Dockerfile
