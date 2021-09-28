FROM php:7.4-cli

ARG user
ARG uid

RUN useradd -G www-data,root -u $uid -d /home/$user $user

COPY ./supervisord.conf /etc/supervisord.conf

ADD supervisord.conf /etc/

RUN docker-php-ext-install pdo_mysql \
    && docker-php-ext-install bcmath \
    && apt-get update \
    && apt-get install -y --no-install-recommends supervisor

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
