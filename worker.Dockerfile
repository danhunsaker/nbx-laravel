FROM php:7.2-cli

LABEL \
    io.nanobox.mounts.1.type="nfs" \
    io.nanobox.mounts.1.from="storage" \
    io.nanobox.mounts.1.dirs.1="storage/app/public" \
    io.nanobox.logs.1.prefix="laravel" \
    io.nanobox.logs.1.path="/var/www/html/storage/logs/laravel.log" \
    io.nanobox.logs.2.prefix="php" \
    io.nanobox.logs.2.path="/var/log/worker/out.log"

WORKDIR /var/www/html/

CMD [ "php", "/var/www/html/artisan", "queue:work", "--sleep=3", "--tries=3", "--daemon" ]

COPY .docker/php.ini /usr/local/etc/php/

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        libgmp-dev \
        libmemcached-dev \
        libz-dev \
        libpq-dev \
        libjpeg-dev \
        libpng-dev \
        libfreetype6-dev \
        libssl-dev \
        libmcrypt-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install -j$(nproc) bcmath gmp pdo_mysql pdo_pgsql iconv \
    && docker-php-ext-configure gd \
      --enable-gd-native-ttf \
      --with-jpeg-dir=/usr/include/ \
      --with-freetype-dir=/usr/include/ && \
      docker-php-ext-install -j$(nproc) gd

RUN printf "\n" | pecl install -o -f redis mcrypt \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis mcrypt

COPY .docker/before_live_worker /opt/nanobox/hooks/before_live

COPY .docker/before_live_all /opt/nanobox/hooks/before_live_all

COPY .docker/after_live_worker /opt/nanobox/hooks/after_live

COPY .docker/after_live_all /opt/nanobox/hooks/after_live_all

COPY --chown=www-data:www-data . .
