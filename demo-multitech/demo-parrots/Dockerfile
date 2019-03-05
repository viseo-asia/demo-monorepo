# BUILD
FROM composer as builder

COPY src /opt/app/src

WORKDIR /opt/app

RUN composer require silex/silex "^2.0"


# RUN
FROM php:7.3-apache

RUN a2enmod rewrite

COPY --from=builder /opt/app/src /var/www/html

COPY --from=builder /opt/app/vendor /var/www/vendor
