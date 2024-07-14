#!/bin/bash

# Color variables
MSG_COLOR="\033[0;32m"    # Green color for messages
RESET_COLOR="\033[0m"     # Reset color

# Download Grafana archive and extract
echo -e "${MSG_COLOR}Downloading and extracting Grafana...${RESET_COLOR}"
wget -q https://dl.grafana.com/oss/release/grafana-8.0.4.linux-amd64.tar.gz
tar -zxvf grafana-8.0.4.linux-amd64.tar.gz
sudo mv grafana-8.0.4 /opt/grafana
rm grafana-8.0.4.linux-amd64.tar.gz  # Clean up archive after extraction

# Check if grafana user exists, create if not
echo -e "${MSG_COLOR}Checking Grafana user...${RESET_COLOR}"
if ! id grafana &>/dev/null; then
    echo -e "${MSG_COLOR}Creating grafana user...${RESET_COLOR}"
    sudo useradd --system --home /var/lib/grafana --shell /bin/false grafana
fi

# Create a systemd service file for Grafana
echo -e "${MSG_COLOR}Creating systemd service file for Grafana...${RESET_COLOR}"
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
echo -e "${MSG_COLOR}Setting ownership and permissions...${RESET_COLOR}"
sudo chown -R grafana:grafana /opt/grafana
sudo chmod -R 755 /opt/grafana

# Start and enable Grafana service
echo -e "${MSG_COLOR}Starting and enabling Grafana service...${RESET_COLOR}"
sudo systemctl daemon-reload
sudo systemctl start grafana
sudo systemctl enable grafana

# Check service status
echo -e "${MSG_COLOR}Checking Grafana service status...${RESET_COLOR}"
sudo systemctl status grafana
