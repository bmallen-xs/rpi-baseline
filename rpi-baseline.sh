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

apt-get install -y motion autossh nfs-common links lynx irssi screen nmap curl

apt-get install -y libnet-ssh2-perl liblwp-protocol-https-perl libnet-openssh-perl libconfig-ini-perl libconfig-simple-perl libxml-simple-perl 

############################################
# Configure Users
id pi001

if [ $? -eq 0 ]
then 
  echo User pi001 already exists
else
  useradd -m --password '$6$RpUQoZyN$ORxZCmeMMh4pQYOyXw6czjK4HZoN3KBd30i0SYvDEBvXDuWgKXQSM.H0wXKaIJeLGplk8QpySFQ/GYfETjIj30' pi001
fi

id pi002

if [ $? -eq 0 ]
then 
  echo User pi002 already exists
else
  useradd -m --password '$6$RpUQoZyN$ORxZCmeMMh4pQYOyXw6czjK4HZoN3KBd30i0SYvDEBvXDuWgKXQSM.H0wXKaIJeLGplk8QpySFQ/GYfETjIj30' pi002
fi

id pi003

if [ $? -eq 0 ]
then 
  echo User pi003 already exists
else
  useradd -m --password '$6$RpUQoZyN$ORxZCmeMMh4pQYOyXw6czjK4HZoN3KBd30i0SYvDEBvXDuWgKXQSM.H0wXKaIJeLGplk8QpySFQ/GYfETjIj30' pi003
fi

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
sed -i "s/^[ \t\v\f]*PermitRootLogin.*/PermitRootLogin no/g" /etc/ssh/sshd_config

############################################
# Configure Checkin
# Todo: update for "Where's my Pi"
crontab -lu pi001 > /root/crontab-pi001.pre

mkdir -p /home/pi001/bin

cat - > /home/pi001/bin/checkin.sh <<EOF
#!/bin/bash

curl http://web.wtfoo.net/pear/check.igc?name=`hostname`\&ip=`/sbin/ifconfig eth0 | grep "inet addr" | cut -f2 -d: | cut -f1 -d" "` >/dev/null 2>&1

EOF

chmod a+x /home/pi001/bin/checkin.sh

echo "*/5 * * * * /home/pi001/bin/checkin.sh" | crontab -u pi001 -

############################################
# Configure Auto SSH Tunnels
sudo -u pi001 ssh-keygen -t rsa -f /home/pi001/.ssh/id_rsa -N ""
sudo -u pi002 ssh-keygen -t rsa -f /home/pi002/.ssh/id_rsa -N ""
sudo -u pi003 ssh-keygen -t rsa -f /home/pi003/.ssh/id_rsa -N ""

sudo -u pi001 sh -c "curl https://github.com/bmallen-xs.keys > /home/pi001/.ssh/authorized_keys"
sudo -u pi002 sh -c "curl https://github.com/bmallen-xs.keys > /home/pi002/.ssh/authorized_keys"
sudo -u pi003 sh -c "curl https://github.com/bmallen-xs.keys > /home/pi003/.ssh/authorized_keys"

############################################
# Configure Wifi
# /etc/wpa_supplicant/wpa_supplicant.conf
cat - > /etc/wpa_supplicant/wpa_supplicant.conf <<EOF
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
	ssid="pifinet"
	psk="pienettest"
}

EOF

############################################
# Configure DNS

############################################
# Configure Backups

############################################
# Configure GPS

############################################
# Configure Auto SSH Tunnels

############################################
# Configure Web Server - apache and/or nginx
apt-get install nginx -y

############################################
# Configure Monitoring Tools - nsca, nrpe, sar
apt-get install sysstat -y
#sed -i "s/ENABLED=\"false\"/ENABLED=\"true\"/g" /etc/default/sysstat

apt-get install nagios-nrpe-server nsca-client -y 

############################################
# Configure iptables
iptables-save > /root/iptables-save.pre


