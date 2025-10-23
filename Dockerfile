# Gunakan PHP 8.2 dengan Apache
FROM php:8.2-apache

# Install ekstensi yang dibutuhkan Laravel
RUN apt-get update && apt-get install -y \
    git unzip libpq-dev libzip-dev zip \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql zip

# Copy semua file project ke container
COPY . /var/www/html

# Set working directory
WORKDIR /var/www/html

# Install Composer
COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer

# Install dependensi Laravel
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Set permission untuk Laravel storage & cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Jalankan perintah Laravel key:generate saat build
RUN php artisan key:generate --ansi || true

# Expose port default Apache (Render akan override dengan $PORT)
EXPOSE 80

# Jalankan server Apache
CMD ["apache2-foreground"]
