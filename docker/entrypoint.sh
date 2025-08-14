#!/usr/bin/env bash
set -e

# Persistent base (Railway Volume mount path)
PERSIST="/var/dolibarr"

# Make sure persistent dirs exist and are writable
mkdir -p "$PERSIST/documents" "$PERSIST/conf"
chown -R www-data:www-data "$PERSIST"

# Link Dolibarr 'documents' to persistent storage
if [ ! -L /var/www/html/documents ]; then
  rm -rf /var/www/html/documents || true
  ln -s "$PERSIST/documents" /var/www/html/documents
fi

# Link Dolibarr 'htdocs/conf' to persistent storage (conf.php lives here)
if [ ! -L /var/www/html/htdocs/conf ]; then
  rm -rf /var/www/html/htdocs/conf || true
  ln -s "$PERSIST/conf" /var/www/html/htdocs/conf
fi

# Permissions for web server
chown -R www-data:www-data /var/www/html

# Start Apache
exec apache2-foreground
