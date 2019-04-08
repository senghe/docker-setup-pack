FROM ubuntu:18.10

# Set the locale
RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8

ENV LANG                                   en_US.UTF-8
ENV LANGUAGE                               en_US:en
ENV LC_ALL                                 en_US.UTF-8

# Update packages
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -y --force-yes update

# https://serverfault.com/a/949998
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y tzdata \
    && ln -fs /usr/share/zoneinfo/Europe/Warsaw /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive tzdata

# Environment
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -y --force-yes update && \
    apt-get -y --force-yes install vim \
    sudo \
    mlocate \
    lsof


# Unofficial PHP7.2 repository
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -y --force-yes update && \
    apt-get -y --force-yes install software-properties-common && \
    add-apt-repository -y ppa:ondrej/php

RUN apt-get install -y curl

# Apache, PHP and other dependencies
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -y --force-yes update && \
    apt-get -y --force-yes install \
    apache2 \
    php7.2 \
    php7.2-common php7.2-cli php7.2-fpm \
    libapache2-mod-php7.2 \
    php7.2 \
    php7.2-fpm \
    php7.2-gd \
    php7.2-mysql \
    php7.2-curl \
    php7.2-cli \
    php7.2-intl \
    php7.2-common \
    php7.2-sqlite \
    php7.2-dom \
    php7.2-simplexml \
    php7.2-xmlwriter \
    php7.2-mbstring \
    php7.2-dev \
    php7.2-bcmath \
    php7.2-zip \
    php7.2-soap \
    php7.2-xdebug \
    php-apcu \
    php-xdebug \
    php-pear \
    php-oauth \
    sudo \
    supervisor \
    iproute2 \
    git \
    build-essential \
    inetutils-ping

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -y --force-yes update && \
        apt-get -y --force-yes install \
        mysql-client

RUN pear install SOAP-0.13.0 Mail

# Settings
ENV USER_UID                        1000
ENV USER_GID                        1000

ENV ENV__DATABASE__HOST            @project-name@_mariadb
ENV ENV__DATABASE__USER            root
ENV ENV__DATABASE__PASSWORD        password
ENV ENV__DATABASE__PORT            3306

RUN a2enmod rewrite headers

# Do not use chmod or setfacl with user @project-name@ beacuse UID and GID for this user will change on container startup!
RUN groupadd -g $USER_GID @project-name@ && \
    useradd --create-home --shell /bin/bash -u $USER_UID -g $USER_GID @project-name@


RUN sed -e 's/;clear_env = no/clear_env = no/' -i /etc/php/7.2/fpm/pool.d/www.conf

# Composer
ENV COMPOSER_HOME /usr/local/composer
ENV PATH /usr/local/composer/vendor/bin:$PATH

RUN echo "export COMPOSER_HOME=/usr/local/composer" >> /etc/profile.d/composer.sh && \
    echo "export PATH=/usr/local/composer/vendor/bin:\$PATH" >> /etc/profile.d/path.sh

RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && chmod 755 /usr/local/bin/composer

RUN groupadd composer && usermod -a -G composer @project-name@ && \
    chown @project-name@:composer $COMPOSER_HOME && \
    chown @project-name@:composer $COMPOSER_HOME -R && \
    chmod 775 $COMPOSER_HOME && \
    chmod 775 $COMPOSER_HOME -R && \
    ln -fs /usr/share/zoneinfo/Europe/Warsaw /etc/localtime && dpkg-reconfigure -f noninteractive tzdata && \
    sudo mkdir -p /var/www/@project-name@/var/cache && \
    sudo mkdir -p /var/www/@project-name@/var/logs && \
    sudo mkdir -p /var/www/@project-name@/var/sessions && \
    sudo chmod -R 777 /var/www/@project-name@/var

# Scripts
COPY container-fs /

RUN chmod u+x /root/scripts -R && \
    chmod u+x /root/init-lamp.sh -R

ENV PATH /root/scripts:$PATH
RUN echo "export PATH=/root/scripts:\$PATH" >> /etc/profile.d/path.sh

CMD ["/root/init-lamp.sh"]
