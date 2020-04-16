FROM centos:8.1.1911

MAINTAINER gmcgrath@princeton.edu<Garrett McGrath>

### DOA FOR NOW, no mod_auth_cas available.


## we need epel for the cobblerd service
RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN dnf -y install epel-release

## we'll be using tftp-server instead of xinet.d to handle those responsibilities.
RUN dnf -y install cobbler cobbler-web syslinux pykickstart tftp-server tftp httpd mod-auth-cas; dnf clean all

RUN systemctl enable httpd; systemctl enable cobblerd; systemctl enable tftp

COPY ./apache/site.conf /etc/httpd/conf.d/
