FROM php:8.1-apache

WORKDIR /app

COPY . /var/www/html

COPY my-apache-config.conf /etc/apache2/sites-available/000-default.conf

RUN pecl install redis \
    && docker-php-ext-enable redis

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

EXPOSE 80

CMD ["apache2-foreground"]