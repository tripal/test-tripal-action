FROM tripalproject/tripaldocker:drupal9.5.x-dev-php8.1-pgsql13

COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
