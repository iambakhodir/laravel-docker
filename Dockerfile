FROM php:7.4-fpm

# Arguments defined in docker-compose.yml
ARG user
ARG uid

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    python \
    python3 \
    python3-distutils \
    python3-apt \
    git-core \
     openssl  \
    libssl-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd xml xmlrpc sockets zip


RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py  \
  && python get-pip.py  \
  && rm get-pip.py  \
  && python -m pip install --upgrade pip

RUN  curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py  \
  && python3 get-pip.py  \
  && rm get-pip.py  \
  && python3 -m pip install --upgrade --force-reinstall pip


RUN curl -sL https://deb.nodesource.com/setup_12.x  | bash -
RUN apt-get -y install nodejs

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

USER root

COPY ./docker-compose/crontab /etc/cron.d
RUN chmod -R 644 /etc/cron.d
# Set working directory
WORKDIR /var/www

USER root
ENTRYPOINT ["docker-php-entrypoint"]


USER $user
# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]

