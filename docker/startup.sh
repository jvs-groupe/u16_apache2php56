#!/bin/bash

##
## Bad previous shutdown...
##
rm -rf /run/apache2/*
rm -rf /var/run/apache2/*

if [ "X$COMPOSERS" != "X" ]; then
  set -f                      # avoid globbing (expansion of *).
  echo "processing composer in : $COMPOSERS..."
  array=(${COMPOSERS//:/ })
  for i in "${!array[@]}"
  do
    crt=${array[i]}
    if [ -d $crt ]; then
      cd $crt
      composer install
    fi
  done
fi;
if [ "X$BOWERS" != "X" ]; then
  set -f                      # avoid globbing (expansion of *).
  echo "processing bower in : $BOWERS..."
  array=(${BOWERS//:/ })
  for i in "${!array[@]}"
  do
    crt=${array[i]}
    if [ -d $crt ]; then
      cd $crt
      bower install --allow-root
    fi
  done
fi;
echo "...all ok..."

##
## PHP config
##
if [ -f /etc/php/5.6/apache2/php.ini.orig ]; then
  sed -e 's/;sendmail_path =/sendmail_path = '\''\/opt\/go\/bin\/mhsendmail --smtp-addr \"'${MAILHOGSERVER}'\:1025\"'\''/g' < /etc/php/5.6/apache2/php.ini.orig > /etc/php/5.6/apache2/php.ini
  rm -f /etc/php/5.6/apache2/php.ini.orig
fi
if [ -f /etc/php/5.6/fpm/php.ini.orig ]; then
  sed -e 's/;sendmail_path =/sendmail_path = '\''\/opt\/go\/bin\/mhsendmail --smtp-addr \"'${MAILHOGSERVER}'\:1025\"'\''/g' < /etc/php/5.6/fpm/php.ini.orig > /etc/php/5.6/fpm/php.ini
  rm -f /etc/php/5.6/fpm/php.ini.orig
fi
if [ -f /etc/php/5.6/cli/php.ini.orig ]; then
  sed -e 's/;sendmail_path =/sendmail_path = '\''\/opt\/go\/bin\/mhsendmail --smtp-addr \"'${MAILHOGSERVER}'\:1025\"'\''/g' < /etc/php/5.6/cli/php.ini.orig > /etc/php/5.6/cli/php.ini
  rm -f /etc/php/5.6/cli/php.ini.orig
fi

##
## Démarage php-fpm
##
/etc/init.d/php5.6-fpm start

##
## Démarrage d'Apache2
##
/usr/sbin/apache2ctl -D FOREGROUND