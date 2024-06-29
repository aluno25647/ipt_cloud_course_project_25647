#!/bin/bash

# Baixar o nginx-vts-exporter
wget https://github.com/hnlq715/nginx-vts-exporter/releases/download/v0.10.3/nginx-vts-exporter-0.10.3.linux-amd64.tar.gz
tar -xvf nginx-vts-exporter-0.10.3.linux-amd64.tar.gz
sudo mv nginx-vts-exporter-0.10.3.linux-amd64/nginx-vts-exporter /usr/local/bin/nginx-vts-exporter

# Criar o arquivo de configuração do nginx-vts-exporter
sudo mkdir -p /etc/nginx-vts-exporter/
cat <<EOF | sudo tee /etc/nginx-vts-exporter/config.yml
nginx_status_url: http://localhost/status
listen_address: :9913
EOF

# Criar o serviço do nginx-vts-exporter para iniciar automaticamente
cat <<EOF | sudo tee /etc/systemd/system/nginx-vts-exporter.service
[Unit]
Description=Nginx VTS Exporter
After=network.target

[Service]
User=root
Group=root
ExecStart=/usr/local/bin/nginx-vts-exporter --insecure --metrics.namespace=nginx --nginx.scrape_uri=http://localhost/status --telemetry.address=:9913 --telemetry.endpoint=/metrics
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Iniciar o serviço do nginx-vts-exporter
sudo systemctl daemon-reload
sudo systemctl start nginx-vts-exporter
sudo systemctl enable nginx-vts-exporter
