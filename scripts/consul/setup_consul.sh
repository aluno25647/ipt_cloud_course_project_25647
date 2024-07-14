#!/bin/bash

# Color variables
MSG_COLOR="\033[1;34m"  # Blue color for messages
ERROR_COLOR="\033[1;31m"  # Red color for errors
RESET_COLOR="\033[0m"  # Reset color

# Display installation message
echo -e "${MSG_COLOR}Installing Consul...${RESET_COLOR}"

# Variables
CONSUL_VERSION="1.11.4"
CONSUL_ZIP="consul_${CONSUL_VERSION}_linux_amd64.zip"
CONSUL_URL="https://releases.hashicorp.com/consul/${CONSUL_VERSION}/${CONSUL_ZIP}"
CONSUL_BIN="/usr/local/bin/consul"

# Install unzip if not installed
if ! command -v unzip &> /dev/null; then
  echo -e "${MSG_COLOR}Installing unzip...${RESET_COLOR}"
  sudo apt-get update
  sudo apt-get install -y unzip
fi

# Download Consul if not already downloaded
if [ ! -f "${CONSUL_ZIP}" ]; then
  echo -e "${MSG_COLOR}Downloading Consul ${CONSUL_VERSION}...${RESET_COLOR}"
  wget "${CONSUL_URL}"
fi

# Install Consul if not already installed
if [ ! -f "${CONSUL_BIN}" ]; then
  echo -e "${MSG_COLOR}Installing Consul ${CONSUL_VERSION}...${RESET_COLOR}"
  unzip "${CONSUL_ZIP}"
  sudo mv consul "${CONSUL_BIN}"
  rm "${CONSUL_ZIP}"
fi

# Create Consul user and directories
if ! id -u consul > /dev/null 2>&1; then
  echo -e "${MSG_COLOR}Creating Consul user...${RESET_COLOR}"
  sudo useradd --system --home /etc/consul.d --shell /bin/false consul
fi

sudo mkdir -p /opt/consul /etc/consul.d
sudo chown -R consul:consul /opt/consul /etc/consul.d

# Create Consul configuration file
echo -e "${MSG_COLOR}Creating Consul configuration file...${RESET_COLOR}"
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
echo -e "${MSG_COLOR}Creating Consul service...${RESET_COLOR}"
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
echo -e "${MSG_COLOR}Reloading systemd...${RESET_COLOR}"
sudo systemctl daemon-reload

echo -e "${MSG_COLOR}Enabling Consul service...${RESET_COLOR}"
sudo systemctl enable consul

echo -e "${MSG_COLOR}Starting Consul service...${RESET_COLOR}"
sudo systemctl start consul

# Check if Consul service is running
if sudo systemctl is-active --quiet consul; then
  echo -e "${MSG_COLOR}Consul installation and setup complete.${RESET_COLOR}"
else
  echo -e "${ERROR_COLOR}Consul failed to start. Check the logs for more details.${RESET_COLOR}"
fi
