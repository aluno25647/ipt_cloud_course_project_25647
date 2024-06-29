#!/bin/bash

# Baixar o Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.35.0/prometheus-2.35.0.linux-amd64.tar.gz
tar -xvf prometheus-2.35.0.linux-amd64.tar.gz
sudo mv prometheus-2.35.0.linux-amd64 /opt/prometheus

# Criar o arquivo de configuração do Prometheus
cat <<EOF > /opt/prometheus/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'web_servers'
    static_configs:
      - targets: ['192.168.44.11:9100', '192.168.44.12:9100', '192.168.44.13:9100']

  - job_name: 'redis_server'
    static_configs:
      - targets: ['192.168.44.10:9100']

  - job_name: 'nginx_loadbalancers'
    static_configs:
      - targets: ['192.168.50.10:9100', '192.168.50.20:9100']
EOF

# Criar o serviço do Prometheus para iniciar automaticamente
cat <<EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Monitoring System
After=network.target

[Service]
Type=simple
ExecStart=/opt/prometheus/prometheus --config.file=/opt/prometheus/prometheus.yml
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Iniciar o serviço do Prometheus
systemctl daemon-reload
systemctl start prometheus
systemctl enable prometheus
