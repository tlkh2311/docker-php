FROM php:5.6-apache
# Install modules
RUN apt-get update && apt-get install -y \
        libc-client2007e-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libicu-dev \
        libkrb5-dev \
        libmcrypt-dev \
        libpng12-dev \
        libpq-dev \
        libssl-dev \
        git \
        bzip2 \
    && docker-php-ext-install \
        iconv \
        intl \
        mbstring \
        mcrypt \
        pgsql \
        zip \
    && docker-php-ext-configure imap --with-imap-ssl --with-kerberos \
    && docker-php-ext-install imap \
    && docker-php-ext-install pgsql \
    && docker-php-ext-install pdo_pgsql \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && a2enmod rewrite \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && curl -sS http://get.sensiolabs.org/php-cs-fixer.phar -o /usr/local/bin/php-cs-fixer && chmod 755 /usr/local/bin/php-cs-fixer \
    && curl -sSL https://nodejs.org/dist/latest/node-v0.12.7-linux-x64.tar.gz | tar --strip-components 1 -C /usr/local -xzf - \
    && curl -sSL https://www.npmjs.com/install.sh | sh \
    && npm install -g \
        jake \
        bower \
        gulp \
    && apt-get clean

COPY php_file_limit.ini /usr/local/etc/php/conf.d/
CMD ["apache2-foreground"]
