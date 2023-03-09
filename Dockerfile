FROM tripalproject/tripaldocker:$IMAGETAG

RUN echo "The image being used is $IMAGETAG"

WORKDIR /var/www/drupal9/web/modules/tripal

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
