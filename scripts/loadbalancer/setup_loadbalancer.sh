#!/bin/bash

# Update package lists
apt-get update

# Install Nginx
apt-get install -y nginx

# Enable services
systemctl enable nginx

# Copy the Nginx configuration file
cp /vagrant/scripts/loadbalancer/nginx.conf /etc/nginx/nginx.conf

# Restart Nginx
systemctl restart nginx

# Install Keepalived
apt-get install -y keepalived

# create a keepalived configuration file
touch /etc/keepalived/keepalived.conf

# Copy the Keepalived configuration file
cp /vagrant/scripts/loadbalancer/keepalived.conf /etc/keepalived/keepalived.conf

# Replace placeholders in the Keepalived configuration
if [ "$1" == "1" ]; then
    sed -i 's/{{ STATE }}/MASTER/' /etc/keepalived/keepalived.conf
    sed -i 's/{{ PRIORITY }}/101/' /etc/keepalived/keepalived.conf
    sed -i 's/{{ ROUTER_ID }}/LB1/' /etc/keepalived/keepalived.conf
elif [ "$1" == "2" ]; then
    sed -i 's/{{ STATE }}/BACKUP/' /etc/keepalived/keepalived.conf
    sed -i 's/{{ PRIORITY }}/100/' /etc/keepalived/keepalived.conf
    sed -i 's/{{ ROUTER_ID }}/LB2/' /etc/keepalived/keepalived.conf
fi

# Start and enable Keepalived
systemctl enable keepalived
systemctl start keepalived
