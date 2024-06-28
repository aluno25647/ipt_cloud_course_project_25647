#!/bin/bash

# Download Grafana archive and extract
wget -q https://dl.grafana.com/oss/release/grafana-8.0.4.linux-amd64.tar.gz
tar -zxvf grafana-8.0.4.linux-amd64.tar.gz
sudo mv grafana-8.0.4 /opt/grafana
rm grafana-8.0.4.linux-amd64.tar.gz  # Clean up archive after extraction

# Check if grafana user exists, create if not
if ! id grafana &>/dev/null; then
    sudo useradd -m -s /bin/bash grafana
fi

# Create a systemd service file for Grafana
cat <<EOF | sudo tee /etc/systemd/system/grafana.service
[Unit]
Description=Grafana
After=network.target

[Service]
Type=simple
User=grafana
Group=grafana
ExecStart=/opt/grafana/bin/grafana-server --config=/opt/grafana/conf/defaults.ini --homepath /opt/grafana
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Adjust ownership and permissions
sudo chown -R grafana:grafana /opt/grafana

# Start and enable Grafana service
sudo systemctl daemon-reload
sudo systemctl start grafana
sudo systemctl enable grafana

# Check service status
sudo systemctl status grafana
