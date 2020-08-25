# This is a docker image for php8 application server
FROM php:8.0-rc-fpm
MAINTAINER Tsukasa Nagashima

EXPOSE 80

COPY ./src/ /php/src/
WORKDIR /php/src/

ENTRYPOINT php artisan serve --port=80

