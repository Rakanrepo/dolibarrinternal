FROM php:8.2-apache

# Packages & PHP extensions Dolibarr needs
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libzip-dev libicu-dev unzip \
 && rm -rf /var/lib/apt/lists/* \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install -j$(nproc) gd mysqli pdo pdo_mysql zip intl

# Enable Apache rewrite
RUN a2enmod rewrite

# Set DocumentRoot to /var/www/html/htdocs (no external conf file needed)
ENV APACHE_DOCUMENT_ROOT=/var/www/html/htdocs
RUN sed -ri 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf /etc/apache2/apache2.conf

# Copy your forked Dolibarr source into the image
COPY . /var/www/html/

# Persistence: create a place for documents & conf and symlink
RUN mkdir -p /var/dolibarr/documents /var/dolibarr/conf \
 && chown -R www-data:www-data /var/www/html /var/dolibarr \
 && rm -rf /var/www/html/documents || true \
 && ln -s /var/dolibarr/documents /var/www/html/documents \
 && rm -rf /var/www/html/htdocs/conf || true \
 && ln -s /var/dolibarr/conf /var/www/html/htdocs/conf

WORKDIR /var/www/html/htdocs
EXPOSE 80
CMD ["apache2-foreground"]
