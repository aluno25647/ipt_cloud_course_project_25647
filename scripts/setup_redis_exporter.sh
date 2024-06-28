#!/bin/bash

# Download and install Redis Exporter
echo "Downloading Redis Exporter..."
wget -O /tmp/redis_exporter.tar.gz https://github.com/oliver006/redis_exporter/releases/download/v1.25.0/redis_exporter-v1.25.0.linux-amd64.tar.gz

echo "Extracting Redis Exporter..."
tar xvf /tmp/redis_exporter.tar.gz -C /tmp
sudo cp /tmp/redis_exporter-v1.25.0.linux-amd64/redis_exporter /usr/local/bin/

# Create a user and group for the Redis Exporter
sudo useradd -rs /bin/false redis_exporter

# Create systemd service file for Redis Exporter
sudo tee /etc/systemd/system/redis_exporter.service > /dev/null <<EOL
[Unit]
Description=Redis Exporter
After=network.target

[Service]
User=redis_exporter
Group=redis_exporter
ExecStart=/usr/local/bin/redis_exporter --redis.addr 127.0.0.1:6379 --web.listen-address :9104

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd, enable and start Redis Exporter service
sudo systemctl daemon-reload
sudo systemctl enable redis_exporter
sudo systemctl start redis_exporter
