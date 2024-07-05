#!/bin/bash
MSG_COLOR="\033[41m"

echo -e "$MSG_COLOR$(hostname): Update package lists\033[0m"
sudo apt-get update

echo -e "$MSG_COLOR$(hostname): Install Apache HTTP Server\033[0m"
sudo apt-get install -y apache2

echo -e "$MSG_COLOR$(hostname): Install PHP 8.1\033[0m"
# Install specific versions of PHP packages
sudo apt install -y --no-install-recommends php8.1

echo -e "$MSG_COLOR$(hostname): Install additional PHP 8.1 modules\033[0m"
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
    php-redis   # Install Redis PHP extension

sudo systemctl restart apache2

echo -e "$MSG_COLOR$(hostname): Install NFS client\033[0m"
sudo apt-get install -y nfs-common

echo -e "$MSG_COLOR$(hostname): Mount GlusterFS volume\033[0m"
sudo mkdir -p /mnt/glusterfs
sudo mount -t nfs 192.168.50.40:/mnt/glusterfs /mnt/glusterfs

# Ensure NFS volume mounts on system reboot
echo '192.168.50.40:/mnt/glusterfs /mnt/glusterfs nfs defaults,_netdev 0 0' | sudo tee -a /etc/fstab

# Ensure correct permissions on mounted directory
sudo chown -R www-data:www-data /mnt/glusterfs
sudo chmod -R 775 /mnt/glusterfs

echo -e "$MSG_COLOR$(hostname): Install Composer (PHP)\033[0m"
cd ~
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

echo -e "$MSG_COLOR$(hostname): Install dependencies for websockets server\033[0m"
cd /vagrant/ws
sudo -u vagrant bash -c 'composer install'

echo -e "$MSG_COLOR$(hostname): Install dependencies for webapp\033[0m"
cd /vagrant/app
sudo -u vagrant bash -c 'composer install'

echo -e "$MSG_COLOR$(hostname): Copy apache config, disable the default site / enable ours\033[0m"
sudo cp /vagrant/provision/projectA.conf /etc/apache2/sites-available/
sudo a2dissite 000-default.conf
sudo a2ensite projectA.conf
sudo systemctl reload apache2

echo -e "$MSG_COLOR$(hostname): Update deploy date @ .env file\033[0m"
cd /vagrant/app
ISO_DATE=$(TZ=Europe/Lisbon date -Iseconds)
sed -i "s/^DEPLOY_DATE=.*/DEPLOY_DATE=\"$ISO_DATE\"/" .env

echo -e "$MSG_COLOR$(hostname): Configure PHP session to use Redis\033[0m"
sudo sed -i 's/^;session.save_handler = files/session.save_handler = redis/' /etc/php/8.1/apache2/php.ini
sudo sed -i 's/^;session.save_path = "\/var\/lib\/php\/sessions"/session.save_path = "tcp:\/\/192.168.50.30:6379"/' /etc/php/8.1/apache2/php.ini

echo -e "$MSG_COLOR$(hostname): Restart Apache to apply changes\033[0m"
sudo systemctl restart apache2

echo -e "$MSG_COLOR$(hostname): Finished!\033[0m"
