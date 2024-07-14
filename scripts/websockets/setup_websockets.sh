#!/bin/bash

# Definindo cores para mensagens
MSG_COLOR="\033[41m"  # Cor de fundo vermelha para mensagens
NC="\033[0m"          # Resetar formatação de cor

# Mensagem informando atualização dos pacotes
echo -e "${MSG_COLOR}$(hostname): Atualizando os pacotes\033[0m"
sudo apt-get update

# Mensagem informando instalação do PHP e extensões necessárias
echo -e "${MSG_COLOR}$(hostname): Instalando PHP e extensões necessárias\033[0m"
sudo apt-get install -y php php-cli php-mbstring php-xml

# Mensagem informando instalação do Redis Server
echo -e "${MSG_COLOR}$(hostname): Instalando Redis Server\033[0m"
sudo apt-get install -y redis-server

# Verifica se existe composer.json e composer.lock e instala dependências do Composer
if [ -f "/vagrant/ws/composer.json" ] && [ -f "/vagrant/ws/composer.lock" ]; then
    echo -e "${MSG_COLOR}$(hostname): Instalando dependências do Composer para WebSocket Server\033[0m"
    cd /vagrant/ws
    sudo -u vagrant bash -c 'composer install --no-plugins --no-scripts --ignore-platform-reqs'
fi

# Configura o serviço systemd para o WebSocket Server
echo -e "${MSG_COLOR}$(hostname): Configurando o serviço systemd para WebSocket Server\033[0m"
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

# Recarrega o daemon do systemd e inicia o serviço WebSocket Server
echo -e "${MSG_COLOR}$(hostname): Recarregando o daemon do systemd e iniciando o serviço WebSocket Server\033[0m"
sudo systemctl daemon-reload
sudo systemctl start websocket-server
sudo systemctl enable websocket-server

echo -e "${MSG_COLOR}$(hostname): Concluído!\033[0m"
