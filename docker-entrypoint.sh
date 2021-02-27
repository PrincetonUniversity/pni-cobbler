#! /bin/bash

## quick monkey patch for a missing file that prevents network systemd from starting.
# touch /etc/sysconfig/network
# mkdir /tmp/cas

echo "configuring cobbler and apache config files"

envsubst < /opt/augeas-modifications.augfile.template | tee /opt/augeas-modifications.augfile

augtool -b -f /opt/augeas-modifications.augfile -s -e


## create whitelist for accsss to web ui.
# cat /etc/cobbler/users.conf.template | envsubst > /etc/cobbler/users.conf
# cat /etc/cobbler/users.conf

##
## apache customizations currently disabled, allow stock configuration to come up just using port ${CLIENTPORT}
#mv /etc/httpd/conf.d/cobbler_web.conf /etc/httpd/conf.d/cobbler_web.conf.old
#cat /etc/httpd/conf.d/cobbler_web.conf.template | envsubst > /etc/httpd/conf.d/cobbler_web.conf
#cat /etc/httpd/conf.d/cas.conf.template | envsubst > /etc/httpd/conf.d/cas.conf
# rm -v /etc/httpd/conf.d/cobbler.conf
# rm -v /etc/httpd/conf.d/welcome.conf

## smoke test for tftp
# chmod 777 /var/lib/tftpboot
echo "hello test file" > /var/lib/tftpboot/hello.txt


##### This will start systemd launching all services.
# exec /usr/sbin/init
# exec /usr/lib/systemd/systemd --log-target=console --show-status
#exec /sbin/init

# exec /usr/bin/supervisord -c /etc/supervisord.conf
/usr/bin/supervisord -c /etc/supervisord.conf
