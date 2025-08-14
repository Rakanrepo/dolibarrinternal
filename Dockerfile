FROM tuxgasy/dolibarr:latest

# Optional: set PHP limits (uncomment if needed)
# ENV PHP_MEMORY_LIMIT=512M \
#     PHP_UPLOAD_MAX_FILESIZE=64M \
#     PHP_POST_MAX_SIZE=64M

# Railway will inject DB env vars; map them to Dolibarr's expected names here if you want:
# ENV DOLI_DB_HOST=${MYSQLHOST} \
#     DOLI_DB_NAME=${MYSQLDATABASE} \
#     DOLI_DB_USER=${MYSQLUSER} \
#     DOLI_DB_PASSWORD=${MYSQLPASSWORD}

# Expose web port (Railway will map automatically)
EXPOSE 80
