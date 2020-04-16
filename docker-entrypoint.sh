#! /bin/bash

## quick monkey patch for a missing file that prevents network systemd from starting.
touch /etc/sysconfig/network

## create whitelist for accsss to web ui.
cat /etc/cobbler/users.conf.template | envsubst > /etc/cobbler/users.conf
cat /etc/cobbler/users.conf

##

cat /etc/httpd/conf.d/cobbler_web.conf | envsubst > /etc/httpd/conf.d/cobbler_web.conf
cat /etc/httpd/conf.d/cas.conf | envsubst > /etc/httpd/conf.d/cas.conf
##### This will start systemd launching all services.
# exec /usr/sbin/init
exec /usr/lib/systemd/systemd --log-target=console --show-status
#exec /sbin/init
