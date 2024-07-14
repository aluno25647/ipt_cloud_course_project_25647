FROM php:8.1-apache

# dependencies and postgres
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    libpq-dev \
    && docker-php-ext-install pdo_pgsql pgsql

RUN a2enmod rewrite

# redis extension
RUN pecl install redis \
    && docker-php-ext-enable redis

# app
COPY . /var/www/html

# apache config
COPY ./my-apache-config.conf /etc/apache2/sites-available/000-default.conf

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# composer and dependencies
WORKDIR /var/www/html/
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-dev --optimize-autoloader

EXPOSE 80

CMD ["apache2-foreground"]
