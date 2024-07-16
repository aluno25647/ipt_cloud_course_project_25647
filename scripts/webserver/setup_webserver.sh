#!/bin/bash

# Definindo cores para os echos
MSG_COLOR="\033[41m"  # Define a cor vermelha de fundo
NC="\033[0m"          # Define a cor padrão (sem cor)

# Mensagem de atualização de listas de pacotes
echo -e "${MSG_COLOR}$(hostname): Update package lists${NC}"
sudo apt-get update

# Mensagem de instalação do servidor Apache HTTP
echo -e "${MSG_COLOR}$(hostname): Install Apache HTTP Server${NC}"
sudo apt-get install -y apache2

# Mensagem de instalação do PHP 8.1
echo -e "${MSG_COLOR}$(hostname): Install PHP 8.1${NC}"
# Instalação de versões específicas dos pacotes PHP
sudo apt install -y --no-install-recommends php8.1

# Mensagem de instalação de módulos adicionais do PHP 8.1
echo -e "${MSG_COLOR}$(hostname): Install additional PHP 8.1 modules${NC}"
sudo apt-get install -y \
    php8.1-cli \
    php8.1-common \
    php8.1-mysql \
    php8.1-pgsql \
    php8.1-pdo \
    php8.1-zip \
    php8.1-gd \
    php8.1-mbstring \
    php8.1-curl \
    php8.1-xml \
    php8.1-bcmath \
    zip \
    unzip \
    php-redis   # Instala a extensão PHP para Redis

# Reinicia o serviço Apache para aplicar as mudanças
sudo systemctl restart apache2

# Mensagem de instalação do Composer (PHP)
echo -e "${MSG_COLOR}$(hostname): Install Composer (PHP)${NC}"
cd ~
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

# # Mensagem de instalação de dependências para o servidor de websockets
# echo -e "${MSG_COLOR}$(hostname): Install dependencies for websockets server${NC}"
# cd /vagrant/ws
# sudo -u vagrant bash -c 'composer install'

# Mensagem de instalação de dependências para a aplicação web
echo -e "${MSG_COLOR}$(hostname): Install dependencies for webapp${NC}"
cd /vagrant/app
sudo -u vagrant bash -c 'composer install'

# Mensagem de cópia do arquivo de configuração do Apache, desabilitando o site padrão e habilitando o nosso
echo -e "${MSG_COLOR}$(hostname): Copy apache config, disable the default site / enable ours${NC}"
sudo cp /vagrant/provision/projectA.conf /etc/apache2/sites-available/
sudo a2dissite 000-default.conf
sudo a2ensite projectA.conf
sudo systemctl reload apache2

# Mensagem de atualização da data de deploy no arquivo .env
echo -e "${MSG_COLOR}$(hostname): Update deploy date @ .env file${NC}"
cd /vagrant/app
ISO_DATE=$(TZ=Europe/Lisbon date -Iseconds)
sed -i "s/^DEPLOY_DATE=.*/DEPLOY_DATE=\"$ISO_DATE\"/" .env

# Mensagem de configuração da sessão PHP para usar Redis
echo -e "${MSG_COLOR}$(hostname): Configure PHP session to use Redis${NC}"
sudo sed -i 's/^;session.save_handler = files/session.save_handler = redis/' /etc/php/8.1/apache2/php.ini
sudo sed -i 's/^;session.save_path = "\/var\/lib\/php\/sessions"/session.save_path = "tcp:\/\/192.168.50.30:6379"/' /etc/php/8.1/apache2/php.ini

# Garante que o diretório /glusterfs/gallery exista
echo -e "${MSG_COLOR}$(hostname): Ensure /glusterfs/gallery directory exists${NC}"
sudo mkdir -p /glusterfs/gallery

# Define permissões para o diretório /glusterfs/gallery
echo -e "${MSG_COLOR}$(hostname): Set permissions for /glusterfs/gallery${NC}"
sudo chown www-data:www-data /glusterfs/gallery
sudo chmod 755 /glusterfs/gallery

# Reinicia o Apache para aplicar as mudanças
echo -e "${MSG_COLOR}$(hostname): Restart Apache to apply changes${NC}"
sudo systemctl restart apache2

# Mensagem de conclusão do script
echo -e "${MSG_COLOR}$(hostname): Finished!${NC}"
