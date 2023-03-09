FROM tripalproject/tripaldocker:drupal9.5.x-dev-php8.1-pgsql13

RUN echo "The image being used is $IMAGETAG"

WORKDIR /var/www/drupal9/web/modules/contrib/tripal

COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
