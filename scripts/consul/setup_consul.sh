#!/bin/bash

echo "Installing Consul..."

# Variables
CONSUL_VERSION="1.11.4"
CONSUL_ZIP="consul_${CONSUL_VERSION}_linux_amd64.zip"
CONSUL_URL="https://releases.hashicorp.com/consul/${CONSUL_VERSION}/${CONSUL_ZIP}"
CONSUL_BIN="/usr/local/bin/consul"

# Install unzip if not installed
if ! command -v unzip &> /dev/null; then
  sudo apt-get update
  sudo apt-get install -y unzip
fi

# Download and install Consul
if [ ! -f "${CONSUL_ZIP}" ]; then
  wget "${CONSUL_URL}"
fi

if [ ! -f "${CONSUL_BIN}" ]; then
  unzip "${CONSUL_ZIP}"
  sudo mv consul "${CONSUL_BIN}"
  rm "${CONSUL_ZIP}"
fi

# Create Consul user and directories
if ! id -u consul > /dev/null 2>&1; then
  sudo useradd --system --home /etc/consul.d --shell /bin/false consul
fi

sudo mkdir --parents /opt/consul /etc/consul.d
sudo chown --recursive consul:consul /opt/consul /etc/consul.d

# Create Consul configuration file
sudo tee /etc/consul.d/consul.hcl > /dev/null <<EOF
datacenter = "dc1"
data_dir = "/opt/consul"
bind_addr = "192.168.50.200"
client_addr = "0.0.0.0"
ui_config {
  enabled = true
}
server = true
bootstrap_expect = 1
EOF

# Create Consul service
sudo tee /etc/systemd/system/consul.service > /dev/null <<EOF
[Unit]
Description=Consul Agent
Documentation=https://www.consul.io/
Requires=network-online.target
After=network-online.target

[Service]
User=consul
Group=consul
ExecStart=${CONSUL_BIN} agent -config-dir=/etc/consul.d/
ExecReload=/bin/kill -HUP \$MAINPID
KillMode=process
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable and start Consul service
sudo systemctl daemon-reload
sudo systemctl enable consul
sudo systemctl start consul

# Check if Consul service is running
if sudo systemctl status consul | grep "active (running)" > /dev/null 2>&1; then
  echo "Consul installation and setup complete."
else
  echo "Consul failed to start. Check the logs for more details."
fi
