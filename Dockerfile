FROM php:5.6-apache
# Install modules
RUN apt-get update && apt-get install -y \
        bzip2 \
        git \
        libc-client2007e-dev \
        libmysqlclient-dev \
        libfreetype6-dev \
        libicu-dev gzip \
        libjpeg62-turbo-dev \
        libkrb5-dev \
        libxml2-dev \
        libmcrypt-dev \
        libpng12-dev \
        libpq-dev \
        libssl-dev \
        postgresql-client-9.4 \
        wget \
    && docker-php-ext-install \
        iconv \
        intl \
        mbstring \
        mcrypt \
        pgsql \
        zip \
    && docker-php-ext-configure imap --with-imap-ssl --with-kerberos \
    && docker-php-ext-install imap \
    && docker-php-ext-install soap \
    && docker-php-ext-install pgsql \
    && docker-php-ext-install pdo_pgsql \
    && docker-php-ext-install mysql \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && a2enmod rewrite \
    && a2enmod proxy \
    && a2enmod proxy_http \
    && a2enmod cgi \
    && a2enmod expires \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && curl -sS http://get.sensiolabs.org/php-cs-fixer.phar -o /usr/local/bin/php-cs-fixer && chmod 755 /usr/local/bin/php-cs-fixer \
    && curl -sSL https://nodejs.org/dist/v0.12.7/node-v0.12.7-linux-x64.tar.gz | tar --strip-components 1 -C /usr/local -xzf - \
    && curl -sSL https://www.npmjs.com/install.sh | sh \
    && npm install -g \
        jake \
        bower \
        gulp \
    && apt-get clean

# grab gosu for easy step-down from root
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu

RUN wget -O pagespeed.deb https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb \
    && dpkg -i pagespeed.deb \
    && rm pagespeed.deb \
    && apt-get -f install

COPY j16sdiz-php.ini /usr/local/etc/php/conf.d/
COPY php_file_limit.ini /usr/local/etc/php/conf.d/
COPY apache_local.conf /etc/apache2/conf-enabled/
RUN echo "application/x-x509-ca-cert pem" >> /etc/mime.types
RUN sed -i 's@^exec@umask 002 ; exec@' /usr/local/bin/apache2-foreground

WORKDIR /var/www
CMD ["apache2-foreground"]
