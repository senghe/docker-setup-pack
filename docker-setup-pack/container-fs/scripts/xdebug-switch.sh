#!/usr/bin/env bash

if [[ -e /etc/php/7.2/apache2/conf.d/20-xdebug.ini ]]; then
    echo "Turning xdebug off"
    mv /etc/php/7.2/apache2/conf.d/20-xdebug.ini /var/20-xdebug.ini
else
    echo "Turning xdebug on"
    mv /var/20-xdebug.ini /etc/php/7.2/apache2/conf.d/20-xdebug.ini
fi

/etc/init.d/apache2 restart
/etc/init.d/php7.2-fpm restart
