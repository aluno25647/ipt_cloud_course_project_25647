#!/bin/bash

# Color variables
MSG_COLOR="\033[0;32m"    # Green color for messages
RESET_COLOR="\033[0m"     # Reset color

# Update package lists
echo -e "${MSG_COLOR}Updating package lists...${RESET_COLOR}"
apt-get update

# Install necessary packages
echo -e "${MSG_COLOR}Installing nginx, keepalived, and unzip...${RESET_COLOR}"
apt-get install -y nginx keepalived unzip

# Enable Nginx service
echo -e "${MSG_COLOR}Enabling Nginx service...${RESET_COLOR}"
systemctl enable nginx

# Copy the Nginx configuration template
echo -e "${MSG_COLOR}Copying Nginx configuration template...${RESET_COLOR}"
mkdir -p /etc/consul-template/templates
cp /vagrant/scripts/loadbalancer/nginx.ctmpl /etc/consul-template/templates/nginx.ctmpl

# Create Consul Template config directory
mkdir -p /etc/consul-template

# Create a Consul Template configuration file
echo -e "${MSG_COLOR}Creating Consul Template configuration file...${RESET_COLOR}"
cat <<EOF > /etc/consul-template/config.hcl
template {
  source      = "/etc/consul-template/templates/nginx.ctmpl"
  destination = "/etc/nginx/nginx.conf"
  command     = "systemctl reload nginx"
}
consul {
  address = "192.168.50.200:8500"
}
EOF

# Install Consul Template
echo -e "${MSG_COLOR}Installing Consul Template ${CONSUL_TEMPLATE_VERSION}...${RESET_COLOR}"
CONSUL_TEMPLATE_VERSION="0.27.2"
wget https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip
unzip consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip
sudo mv consul-template /usr/local/bin/
rm consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip

# Create Consul Template service file
echo -e "${MSG_COLOR}Creating Consul Template service file...${RESET_COLOR}"
sudo tee /etc/systemd/system/consul-template.service > /dev/null <<EOF
[Unit]
Description=Consul Template
Requires=network-online.target
After=network-online.target

[Service]
ExecStart=/usr/local/bin/consul-template -config /etc/consul-template/config.hcl
ExecReload=/bin/kill -HUP \$MAINPID
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Start and enable Consul Template
echo -e "${MSG_COLOR}Starting and enabling Consul Template service...${RESET_COLOR}"
systemctl enable consul-template
systemctl start consul-template

# Copy the initial Nginx configuration file
echo -e "${MSG_COLOR}Copying initial Nginx configuration file...${RESET_COLOR}"
cp /vagrant/scripts/loadbalancer/nginx.conf /etc/nginx/nginx.conf

# Restart Nginx to apply initial configuration
echo -e "${MSG_COLOR}Restarting Nginx to apply initial configuration...${RESET_COLOR}"
systemctl restart nginx

# Install Keepalived
echo -e "${MSG_COLOR}Installing Keepalived...${RESET_COLOR}"
apt-get install -y keepalived

# Create a Keepalived configuration file
echo -e "${MSG_COLOR}Creating Keepalived configuration file...${RESET_COLOR}"
touch /etc/keepalived/keepalived.conf

# Copy the Keepalived configuration file
echo -e "${MSG_COLOR}Copying Keepalived configuration file...${RESET_COLOR}"
cp /vagrant/scripts/loadbalancer/keepalived.conf /etc/keepalived/keepalived.conf

# Replace placeholders in the Keepalived configuration based on LB_ID parameter
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
echo -e "${MSG_COLOR}Starting and enabling Keepalived...${RESET_COLOR}"
systemctl enable keepalived
systemctl start keepalived

echo -e "${MSG_COLOR}Load balancer setup and Consul Template installation complete.${RESET_COLOR}"
