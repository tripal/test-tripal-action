#!/bin/sh -l

service postgresql restart
cd /var/www/drupal9/web/modules/contrib/tripal
drush en tripal tripal_chado --yes
phpunit
