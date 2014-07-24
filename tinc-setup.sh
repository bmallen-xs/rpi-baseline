#!/bin/bash
#
# Tinc Node Configuration
#

#################################
# Config Items
#################################
HOST=`hostname | cut -f1 -d. | tr -d "-"`
MYIP=10.240.0.5
TUN_NAME=myvpn

#################################
# Install tinc
#################################
apt-get install -y tinc

#################################
# Create Required Directories
#################################
mkdir -p /etc/tinc/$TUN_NAME/hosts

#################################
# Setup This Host Config
#################################
cat <<EOF >/etc/tinc/$TUN_NAME/hosts/$HOST
Subnet = $MYIP/32

EOF

#################################
# Setup tunnel Config
#################################
cat <<EOF >/etc/tinc/$TUN_NAME/tinc.conf
Name = $HOST
AddressFamily = ipv4
Interface = tun0
ConnectTo = ares
EOF

#################################
# Generate Key
#################################
tincd -n $TUN_NAME -K4096

#################################
# Setup ifconfig scripts
#################################
cat <<EOF >/etc/tinc/$TUN_NAME/tinc-up
#!/bin/sh
ifconfig \$INTERFACE $MYIP netmask 255.255.255.0
EOF

cat <<EOF >/etc/tinc/$TUN_NAME/tinc-down
#!/bin/sh
ifconfig $INTERFACE down
EOF

chmod 755 /etc/tinc/$TUN_NAME/tinc-*

#################################
# Set this tunnel to start on boot
#################################
echo $TUN_NAME >> /etc/tinc/nets.boot

#################################
# Import host files for peers
#################################


#################################
# Start Tunnel
#################################
service tincd start
