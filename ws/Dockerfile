FROM php:8.1-cli

COPY . /usr/src/app

RUN docker-php-ext-install sockets



RUN chown -R www-data:www-data /usr/src/app
RUN chmod -R 755 /usr/src/app

WORKDIR /usr/src/app

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-dev --optimize-autoloader

EXPOSE 8080

CMD ["php", "websocket-server.php"]