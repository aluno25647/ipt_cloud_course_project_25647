#!/bin/bash

# Instala PHP e extensões necessárias
sudo apt-get update
sudo apt-get install -y php php-cli php-mbstring php-xml

# Instala Redis
sudo apt-get install -y redis-server

# Se existir composer.json e composer.lock, instala as dependências do Composer
if [ -f "/vagrant/ws/composer.json" ] && [ -f "/vagrant/ws/composer.lock" ]; then
    cd /vagrant/ws
    sudo -u vagrant bash -c 'composer install --no-plugins --no-scripts --ignore-platform-reqs'
fi

# Configura o serviço systemd para o WebSocket Server
sudo bash -c 'cat <<EOF > /etc/systemd/system/websocket-server.service
[Unit]
Description=WebSocket Server
After=network.target

[Service]
Type=simple
User=vagrant
ExecStart=/usr/bin/php /vagrant/ws/websockets_server.php
Restart=always

[Install]
WantedBy=multi-user.target
EOF'

# Recarrega o daemon do systemd e inicia o serviço
sudo systemctl daemon-reload
sudo systemctl start websocket-server
sudo systemctl enable websocket-server
