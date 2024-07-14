#!/bin/bash

# Color variables
MSG_COLOR="\033[0;32m"    # Green color for messages
RESET_COLOR="\033[0m"     # Reset color

# Download and install node_exporter
echo -e "${MSG_COLOR}Downloading and installing node_exporter...${RESET_COLOR}"
wget https://github.com/prometheus/node_exporter/releases/download/v1.2.2/node_exporter-1.2.2.linux-amd64.tar.gz
tar -xvf node_exporter-1.2.2.linux-amd64.tar.gz
sudo mv node_exporter-1.2.2.linux-amd64/node_exporter /usr/local/bin/
rm node_exporter-1.2.2.linux-amd64.tar.gz

# Configure node_exporter service
echo -e "${MSG_COLOR}Configuring node_exporter service...${RESET_COLOR}"
cat <<EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
After=network.target

[Service]
ExecStart=/usr/local/bin/node_exporter
Restart=always

[Install]
WantedBy=default.target
EOF

# Start and enable node_exporter service
echo -e "${MSG_COLOR}Starting and enabling node_exporter service...${RESET_COLOR}"
systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter

echo -e "${MSG_COLOR}Node Exporter setup complete.${RESET_COLOR}"
