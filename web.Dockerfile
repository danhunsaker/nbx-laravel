FROM laradock_nginx

LABEL \
  io.nanobox.http_port="80" \
  io.nanobox.force_ssl="true" \
  io.nanobox.logs.1.path="/var/log/web/out.log" \
  io.nanobox.logs.1.prefix="nginx" \
  io.nanobox.mounts.1.type="nfs" \
  io.nanobox.mounts.1.from="storage" \
  io.nanobox.mounts.1.dirs.1="/var/www/storage/app/public"

WORKDIR /var/www

RUN echo "upstream php-upstream { server localhost:9000; }" > /etc/nginx/conf.d/upstream.conf

RUN ["mkdir", "-p", "/etc/nginx/sites-available", "/opt/nanobox/hooks"]

COPY .docker/web.conf /etc/nginx/sites-available/

COPY .docker/before_live /opt/nanobox/hooks/

COPY --chown=www-data:www-data . .
