#!/bin/bash

# Update package lists
apt-get update

# Install necessary packages
apt-get install -y nginx keepalived unzip

# Enable Nginx service
systemctl enable nginx

# Copy the Nginx configuration template
mkdir -p /etc/consul-template/templates
cp /vagrant/scripts/loadbalancer/nginx.ctmpl /etc/consul-template/templates/nginx.ctmpl

# Create Consul Template config directory
mkdir -p /etc/consul-template

# Create a Consul Template configuration file
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
CONSUL_TEMPLATE_VERSION="0.27.2"
wget https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip
unzip consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip
sudo mv consul-template /usr/local/bin/
rm consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip

# Create Consul Template service file
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
systemctl enable consul-template
systemctl start consul-template

# Copy the Nginx configuration file to initiate the first run
cp /vagrant/scripts/loadbalancer/nginx.conf /etc/nginx/nginx.conf

# Restart Nginx to apply initial configuration
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

echo "Load balancer setup and Consul Template installation complete."
