FROM php:7.4.29-apache
LABEL maintainer="Francesco Bianco <info@javanile.org>"

ENV LAYER_BREAK=true
ENV VT_VERSION="7.1.0-php7.4" \
    DATABASE_PACKAGE="mariadb-server-10.5" \
    COMPOSER_HOME=/usr/src/vtiger \
    PATH="/usr/src/vtiger/vendor/bin:$PATH"

#COPY vtiger.json .symvol /usr/src/vtiger/
#COPY vtiger-ssl.* /etc/apache2/ssl/
#COPY 000-default.conf /etc/apache2/sites-available/

RUN apt-get update && \
    apt-get install --no-install-recommends -y libzip-dev zlib1g-dev libc-client-dev libkrb5-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libxml2-dev cron rsyslog zip unzip socat vim nano && \
    docker-php-ext-configure gd && ${LAYER_BREAK}
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install imap exif mysqli pdo pdo_mysql zip gd xml && \
    echo "cron.* /var/log/cron.log" >> /etc/rsyslog.conf && rm -fr /etc/cron.* && mkdir /etc/cron.d && ${LAYER_BREAK}
RUN curl -o composer -sL https://getcomposer.org/composer.phar && \
    php composer global require javanile/http-robot:0.0.2 javanile/mysql-import:0.0.15 javanile/vtiger-cli:0.0.4 && \
    php composer clearcache && rm composer && ${LAYER_BREAK}
RUN curl -sL https://javanile.github.io/symvol/setup.sh?v=0.0.2 | bash - && ${LAYER_BREAK}
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    a2enmod ssl && a2enmod rewrite && ${LAYER_BREAK}
RUN apt-get clean && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

COPY php.ini /usr/local/etc/php/

#COPY develop-install.sh /usr/local/bin/
#RUN develop-install.sh
#COPY health.php polyfill.php /var/www/html/
#COPY vtiger-*.sh /usr/local/bin/
#COPY vtiger-*.php /usr/src/vtiger/

#RUN vtiger-install.sh --assert-mysql --dump --remove-mysql
#RUN cd /var/www/html/vtlib/Vtiger/ && \
#    sed -e 's!realpath(!__realpath__(!' -ri Utils.php Deprecated.php && \
#    symvol move /var/www/html /usr/src/vtiger/volume

#COPY config.inc.php /usr/src/vtiger/
#COPY LoggerManager.php /var/www/html/libraries/log4php/
#COPY config.performance.php health.php loading.php  /var/www/html/
#COPY crontab /etc/

#VOLUME ["/var/lib/vtiger"]

COPY vtiger-info.php /usr/src/vtiger/
COPY vtiger-install.php /usr/src/vtiger/
COPY vtiger-health.php /usr/src/vtiger/

COPY vtiger-foreground.sh /usr/local/bin/
COPY vtiger-install.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/vtiger-foreground.sh && \
	chmod +x /usr/local/bin/vtiger-install.sh

WORKDIR /app

CMD ["vtiger-foreground.sh"]
