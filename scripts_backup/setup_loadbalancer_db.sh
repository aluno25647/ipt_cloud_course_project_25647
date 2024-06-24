#!/bin/bash

# Update package lists
apt-get update

# Install Nginx and Keepalived
apt-get install -y nginx keepalived

# Enable services
systemctl enable nginx
systemctl enable keepalived

# create a keepalived configuration file
touch /etc/keepalived/keepalived.conf

# Copy the Nginx configuration file
cp /vagrant/scripts/nginx_db.conf /etc/nginx/nginx.conf

# Restart Nginx
systemctl restart nginx