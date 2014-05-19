#!/bin/bash
set -e

# Raspberry Pi Baseline Configuration Script
# Ben Allen
#
# https://github.com/bmallen-xs/rpi-baseline/
# 
# Usage: $ sudo ./rpi-baseline.sh
#

############################################
# Check if this script is running as root.
if [[ `whoami` != "root" ]]
then
  echo "This install must be run as root or with sudo."
  exit
fi

############################################
# Set hostname based on MAC address.
MAC="$( sed "s/^.*macaddr=[0-9A-F:]\{9\}\([0-9A-F:]*\) .*$/\1/;s/:/-/g" /proc/cmdline )"

echo $MAC > /etc/hostname

hostname $MAC

# Update Hosts file with new hostname
sed -i "s/127.0.1.1.*/127.0.1.1\t$MAC/g" /etc/hosts

############################################
# Install needed packages
apt-get update -y 

apt-get upgrade -y

apt-get install -y motion autossh nfs-common links lynx irssi screen nmap 

apt-get install -y libnet-ssh2-perl liblwp-protocol-https-perl libnet-openssh-perl libconfig-ini-perl libconfig-simple-perl libxml-simple-perl 

############################################
# Configure Users
useradd -m --password '$6$RpUQoZyN$ORxZCmeMMh4pQYOyXw6czjK4HZoN3KBd30i0SYvDEBvXDuWgKXQSM.H0wXKaIJeLGplk8QpySFQ/GYfETjIj30' pi001
useradd -m --password '$6$RpUQoZyN$ORxZCmeMMh4pQYOyXw6czjK4HZoN3KBd30i0SYvDEBvXDuWgKXQSM.H0wXKaIJeLGplk8QpySFQ/GYfETjIj30' pi002
useradd -m --password '$6$RpUQoZyN$ORxZCmeMMh4pQYOyXw6czjK4HZoN3KBd30i0SYvDEBvXDuWgKXQSM.H0wXKaIJeLGplk8QpySFQ/GYfETjIj30' pi003

############################################
# Configure Groups
groupadd piadmin
usermod -a -G piadmin pi001
usermod -a -G piadmin pi002
usermod -a -G piadmin pi003

############################################
# Configure sudoers
echo "%piadmin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

############################################
# Configure Motion

############################################
# Configure SSHD

############################################
# Configure Checkin

############################################
# Configure Auto SSH Tunnels

############################################
# Configure Wifi
# /etc/wpa_supplicant/wpa_supplicant.conf

############################################
# Configure DNS

############################################
# Configure Web Server - apache and/or nginx

############################################
# Configure Monitoring Tools - nsca, sar, ksar

############################################
# Configure iptables



