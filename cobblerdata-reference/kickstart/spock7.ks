#version=RHEL7
# System authorization information
auth --enableshadow --passalgo=sha512

# System bootloader configuration
bootloader --location=mbr --boot-drive=$sda

# Use text mode install
text

# Firewall configuration
firewall --enabled

# do not run the Setup Agent on first boot
firstboot --disable

# System keyboard
keyboard --vckeymap=us --xlayouts='us'

# System language
lang en_US.UTF-8

#disable on first boot eula
eula --agreed



## this should work for centos or springdale without any additional help
url --url=$tree

# pretty sure this does nothing.
##$yum_repo_stanza

# Network information - cobbler supplied snippet
$SNIPPET('network_config')
# Reboot after installation
reboot

## imaging environment
##rootpw --iscrypted ${DEFAULTROOTHASH} ##TODO: this will only work with envsub so you can't mount kickstart files but must merge them at launch.
skipx
timezone America/New_York --isUtc

## wipe disk
zerombr
clearpart --all --drives=$sda --initlabel


# Disk partitioning information
part biosboot --fstype=biosboot --size=1
part /boot --fstype="xfs" --ondisk=sda --size=500
part pv.14 --fstype="lvmpv" --ondisk=sda --size=1 --grow
volgroup sl_base --pesize=4096 pv.14
logvol /  --fstype="xfs" --size=55000 --name=root --vgname=sl_base
logvol swap  --fstype="swap" --size=8000 --name=swap --vgname=sl_base
logvol /var/tmp  --fstype="xfs" --size=5000 --name=var_tmp --vgname=sl_base --fsoptions="nosuid,noatime"
logvol /var  --fstype="xfs" --size=10000 --name=var --vgname=sl_base --fsoptions="noatime"
logvol /home  --fstype="xfs" --size=1000 --name=home --vgname=sl_base
logvol /tmp  --fstype="xfs" --size=8000 --name=tmp --vgname=sl_base --fsoptions="nosuid,noatime" --grow
$extrapart1
$extrapart2
$extrapart3
$extrapart4
$extrapart5
$extrapart6
$extrapart7
$extrapart8
$extrapart9


# we don't want networkmanager, for now, gets confused on some hosts
services --disabled=NetworkManager --enabled=network,puppet

%pre
$SNIPPET('log_ks_pre')
$SNIPPET('kickstart_start')
$SNIPPET('pre_install_network_config')
# Enable installation monitoring
$SNIPPET('pre_anamon')
%end

%packages --nobase
$SNIPPET('func_install_if_enabled')
wget
puppet
-NetworkManager
-NetworkManager-tui

%end


%post
$SNIPPET('log_ks_post')
# Start yum configuration
$yum_config_stanza
# End yum configuration
$SNIPPET('post_install_kernel_options')
$SNIPPET('post_install_network_config')
$SNIPPET('func_register_if_enabled')
$SNIPPET('download_config_files')
$SNIPPET('koan_environment')
##$SNIPPET('redhat_register')

# remove first start garbage
rm /etc/systemd/system/multi-user.target.wants/initial-setup-text.service
rm /etc/systemd/system/graphical.target.wants/initial-setup-text.service

$SNIPPET('cobbler_register')

## setup puppet 6 on the target
#$SNIPPET('puppet6conf-rhel7')
$SNIPPET('/opt/import/kickstart-snippets/puppet6conf-rhel7')


# Enable post-install boot notification
$SNIPPET('post_anamon')
# Start final steps
$SNIPPET('kickstart_done')
# End final steps
%end
