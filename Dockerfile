FROM php:8.2-fpm

# Instala dependências
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim unzip git curl \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Cria diretório da aplicação
WORKDIR /var/www

# Copia arquivos pro container
COPY . .

# Instala dependências PHP
RUN composer install --no-dev --optimize-autoloader

# Gera key e linka o storage (vai ser rodado em runtime também, mas ajuda no cache)
RUN php artisan key:generate && php artisan storage:link

# Porta que o Laravel vai rodar
EXPOSE 8000

# Comando para iniciar a aplicação
CMD php artisan serve --host=0.0.0.0 --port=8000
