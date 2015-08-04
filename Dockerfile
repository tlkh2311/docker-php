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
    && docker-php-ext-install \
        iconv \
        intl \
        mbstring \
        mcrypt \
        pgsql \
        zip \
    && docker-php-ext-configure imap --with-imap-ssl --with-kerberos \
    && docker-php-ext-install imap \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

CMD ["apache2-foreground"]
