# Version 1.0.0

FROM jvsgroupe/u16_core
MAINTAINER Jérôme KLAM, "jerome.klam@jvs.fr"

## Installation des utilitaires de base
RUN apt-get update && apt-get -y install language-pack-en
RUN apt-get update && apt-get -y install wget tzdata curl zip

## Installation d'Apache 2
RUN apt-get update && apt-get install -y apt-utils apache2 apache2-doc apache2-utils libexpat1 ssl-cert

## Add packages
RUN apt-get update && apt-get install -y software-properties-common python-software-properties
RUN apt-get update && LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/apache2
RUN apt-get update && apt-get -y upgrade apache2

## Installation de PHP 5.6
RUN apt-get update && LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
RUN apt-get update && apt-get install -y imagemagick graphicsmagick libapache2-mod-php5.6 php5.6-bcmath php5.6-bz2 php5.6-cli php5.6-common php5.6-curl php5.6-dba php5.6-gd php5.6-gmp php5.6-imap php5.6-intl php5.6-ldap php5.6-mbstring php5.6-mcrypt php5.6-mysql php5.6-odbc php5.6-pgsql php5.6-recode php5.6-snmp php5.6-soap php5.6-sqlite php5.6-tidy php5.6-xml php5.6-xmlrpc php5.6-xsl php5.6-zip 
RUN apt-get update && apt-get install -y php-gnupg php-imagick php-mongodb php-streams php-fxsl
RUN apt-get update && apt-get install -y php5.6-xdebug php5.6-fpm 

## git
RUN apt-get update && apt-get install -y git

## Go and mhsendmail
RUN apt-get update && apt-get install -y golang-go
RUN mkdir -p /opt/go
ENV GOPATH /opt/go
RUN go get github.com/mailhog/mhsendmail

## Installation des utilitaires
RUN apt-get install -y vim nano

## Pré-requis ORACLE
RUN apt-get install -y apt-transport-https

## Installation de composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/bin/composer
# module dev avec liens
RUN composer global require "jeromeklam/composer-localdev"
RUN composer global update

## Variables d'environnement
ENV DOCUMENTROOT www
ENV SERVERNAME apache2php56.local.fr
ENV ERRORLOG error.log
ENV ACCESSLOG access.log
ENV APP_SERVERNAME localhost
ENV MAILHOGSERVER mailhog

## Suppression du vhost par défaut
RUN rm /etc/apache2/sites-enabled/000-default.conf

## Ajout des fichiers virtualhost
RUN mv /etc/apache2/apache2.conf /etc/apache2/apache2.conf.orig 
RUN sed -e 's/# Global configuration/# Global configuration\nServerName localhost/g' < /etc/apache2/apache2.conf.orig > /etc/apache2/apache2.conf

## Activation des modules SSL et REWRITE
RUN a2enmod ssl
RUN a2enmod env
RUN a2enmod rewrite
RUN a2enmod headers
RUN a2enmod proxy_fcgi
RUN a2enmod setenvif
RUN a2enconf php5.6-fpm 
RUN a2dismod php5.6
RUN a2dismod mpm_prefork
RUN a2enmod mpm_event 
RUN a2enmod http2

## On expose le port 80 et 443
EXPOSE 80
EXPOSE 443

VOLUME /var/www
VOLUME /var/log/apache2

## Fin d'installation
RUN apt-get update
RUN apt-get -y install php-gd

## TimeZone
RUN echo "Europe/Paris" > /etc/timezone
RUN rm /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

## Bower & grunt
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g --unsafe-perm bower grunt
RUN npm install -g --unsafe-perm dredd 
RUN npm install -g --unsafe-perm aglio

## Système
RUN apt-get update
RUN apt-get install -y dos2unix

## Adding phpUnit
RUN wget -O phpunit https://phar.phpunit.de/phpunit-6.phar
RUN chmod +x phpunit
RUN mv ./phpunit /usr/local/bin/phpunit

## On déplace les fichiers de configuration s'il n'existe pas et on démarre apache, ...
ADD ./docker/startup.sh /
RUN chmod +x /startup.sh
CMD ["/bin/bash", "/startup.sh"]