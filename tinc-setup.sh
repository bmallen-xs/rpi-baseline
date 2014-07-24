#!/bin/bash
#
# Tinc Node Configuration
#

#################################
# Config Items
#################################
HOST=something
TUN_NAME=myvpn

#################################
# Install tinc
#################################
apt-get install tinc

#################################
# Create Required Directories
#################################
mkdir -p /etc/tinc/$TUN_NAME/hosts

#################################
# Setup This Host Config
#################################
vi /etc/tinc/$TUN_NAME/hosts/$HOST

#################################
# Setup tunnel Config
#################################
vi /etc/tinc/$TUN_NAME/tinc.conf

#################################
# Generate Key
#################################
tincd -n $TUN_NAME -K4096

#################################
# Setup ifconfig scripts
#################################
cat <<EOF >/etc/tinc/$TUN_NAME/tinc-up
#!/bin/sh
ifconfig $INTERFACE 10.240.0.4 netmask 255.255.255.0
EOF

cat <<EOF >/etc/tinc/$TUN_NAME/tinc-down
ifconfig $INTERFACE down
EOF

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
