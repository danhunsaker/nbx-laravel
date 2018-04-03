FROM laradock_php-worker

LABEL \
  io.nanobox.logs.1.path="/var/log/php.log" \
  io.nanobox.logs.1.prefix="php" \
  io.nanobox.logs.2.path="/var/www/storage/logs/laravel.log" \
  io.nanobox.logs.2.prefix="laravel" \
  io.nanobox.mounts.1.type="nfs" \
  io.nanobox.mounts.1.from="storage" \
  io.nanobox.mounts.1.dirs.1="/var/www/storage/app/public"

WORKDIR /var/www

COPY --chown=www-data:www-data . .
