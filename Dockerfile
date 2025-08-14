FROM php:8.2-apache

# OS deps
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libzip-dev libxml2-dev libicu-dev \
    libonig-dev libldap2-dev libxslt1.1 libxslt-dev libcurl4-openssl-dev unzip \
    && rm -rf /var/lib/apt/lists/*

# PHP extensions required/recommended by Dolibarr
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install -j$(nproc) gd mysqli pdo pdo_mysql zip intl opcache xml mbstring soap exif

# Apache config: enable rewrite/headers
RUN a2enmod rewrite headers

# Set Apache DocumentRoot to /var/www/html/htdocs
COPY docker/000-default.conf /etc/apache2/sites-available/000-default.conf

# Put Dolibarr under /var/www/html (the repo content is the app)
COPY . /var/www/html/

# Ensure web files owned by www-data
RUN chown -R www-data:www-data /var/www/html

# Prepare persistent data mount (Railway Volume) at /var/dolibarr
# We'll symlink Dolibarr's 'documents' and 'htdocs/conf' to this mount.
RUN mkdir -p /var/dolibarr && chown -R www-data:www-data /var/dolibarr

# Entrypoint to create symlinks and start Apache
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /var/www/html/htdocs
EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
