FROM laradock_php-fpm

LABEL \
  io.nanobox.tcp_ports.1="9000:9000" \
  io.nanobox.logs.1.path="/var/log/fpm/out.log" \
  io.nanobox.logs.1.prefix="php-fpm" \
  io.nanobox.logs.2.path="/var/www/storage/logs/laravel.log" \
  io.nanobox.logs.2.prefix="laravel" \
  io.nanobox.mounts.1.type="nfs" \
  io.nanobox.mounts.1.from="storage" \
  io.nanobox.mounts.1.dirs.1="/var/www/storage/app/public"

WORKDIR /var/www

COPY .docker/php.ini /usr/local/etc/php/php.ini

COPY --chown=www-data:www-data . .
