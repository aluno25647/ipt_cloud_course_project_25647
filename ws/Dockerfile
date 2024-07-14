FROM php:8.1-cli

# dependencies and postgres
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    libpq-dev \
    && docker-php-ext-install pdo_pgsql pgsql

# Instalar a extensão Redis
RUN pecl install redis \
    && docker-php-ext-enable redis

COPY . /usr/src/app


RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# composer and dependencies
WORKDIR /usr/src/app
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-dev --optimize-autoloader

EXPOSE 8000

CMD ["php", "websockets_server.php"]