#!/bin/bash

# Download Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.35.0/prometheus-2.35.0.linux-amd64.tar.gz
tar -xvf prometheus-2.35.0.linux-amd64.tar.gz
sudo mv prometheus-2.35.0.linux-amd64 /opt/prometheus

# Create the Prometheus configuration file
cat <<EOF > /opt/prometheus/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'web_servers'
    consul_sd_configs:
      - server: '192.168.50.200:8500'
        services: ['web-server']
    relabel_configs:
      - source_labels: [__meta_consul_service]
        regex: (.*)
        target_label: job
        replacement: \${1}
      - source_labels: [__meta_consul_service_address]
        target_label: __address__
        replacement: \${1}:9100

  - job_name: 'sessions-server'
    static_configs:
      - targets: ['192.168.50.30:9100']

  - job_name: 'websockets-server'
    static_configs:
      - targets: ['192.168.50.50:9100']

  - job_name: 'glusterfs'
    static_configs:
      - targets: ['192.168.50.40:9100']

  - job_name: 'consul_server'
    static_configs:
      - targets: ['192.168.50.200:9100']

  - job_name: 'nginx_loadbalancers'
    static_configs:
      - targets: ['192.168.50.10:9100', '192.168.50.20:9100']

  - job_name: 'grafana'
    static_configs:
      - targets: ['192.168.50.70:9100']
EOF

# Create the Prometheus service file
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

# Start the Prometheus service
systemctl daemon-reload
systemctl start prometheus
systemctl enable prometheus
