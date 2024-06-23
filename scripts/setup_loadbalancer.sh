#!/bin/bash

apt-get update
apt-get install -y nginx keepalived
systemctl enable nginx
systemctl enable keepalived

cp /vagrant/scripts/nginx.conf /etc/nginx/nginx.conf
systemctl restart nginx
