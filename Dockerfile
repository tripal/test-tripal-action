FROM tripalproject/tripaldocker:drupal9.5.x-dev-php8.1-pgsql13

COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

## Expose http, xdebug and psql port
EXPOSE 80 5432 9003

ENTRYPOINT ["/entrypoint.sh"]
