#! /bin/bash


# Set the DNS name server
sed -i -e 's/DNS=/DNS=8.8.8.8 /' /etc/systemd/resolved.conf


# Restart the system
service systemd-resolved restart
