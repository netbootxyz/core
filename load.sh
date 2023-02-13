#!/bin/bash

# stubbing out networking detection for vlans and static ips
# ip=dhcp

# address=1.2.3.4 netmask=255.255.255.0 gateway=1.2.3.1 vlan=212 BOOTIF=${netX/mac} dns=1.1.1.1
# determine interface from given mac on kernel command-line


# modprobe 8021q
# vconfig add eth0 212
#ifconfig eth0.212 1.2.3.4 netmask 255.255.255.0 up
#route add default gw 192.168.254.1
#set dns resolve.conf
# if dhcp use dhclient <interface>
#
core_update()
{
    if grep -qs "core_sha=" /proc/cmdline
    then
      echo "[core] SHA specified... checking out core to specified SHA..."
      CORE_SHA=`cat /proc/cmdline | grep -o 'core_sha=[^ ,]\+' | awk -F'=' {'print $2'}`
      mv /opt/core /opt/core.orig
      git clone --branch ${CORE_SHA} git@github.com:netbootxyz/core.git /opt/core
    fi
}

core_check()
{
    if ! grep -qs "playbook=" /proc/cmdline
    then
      echo "[core] Playbook not set... not doing anything..."
      exit 0
    fi
    echo "[core] Playbook set... linking playbook to run on boot..."
    PLAYBOOK=`cat /proc/cmdline | grep -o 'playbook=[^ ,]\+' | awk -F'=' {'print $2'}`
    ln -s /opt/core/$PLAYBOOK.yml /opt/core/playbook.yml
}

run_playbook()
{
    cd /opt/core
    ansible-playbook -i localhost playbook.yml
}

main()
{
    core_update
    core_check
    run_playbook

    # keep container open for debug... maybe we make this adjustable via cmdline
    sleep 1200
}

main
