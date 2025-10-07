# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.22

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Grocy Custom Build version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="custom-build"

RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache --virtual=build-dependencies \
    git \
    yarn \
    php84-dev \
    gcc \
    g++ \
    make \
    autoconf && \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    php84-gd \
    php84-intl \
    php84-ldap \
    php84-opcache \
    php84-pdo \
    php84-pdo_sqlite \
    php84-tokenizer \
    php84-pear && \
  echo "**** install inotify via PECL ****" && \
  pecl84 install inotify && \
  echo "extension=inotify.so" > /etc/php84/conf.d/inotify.ini && \
  echo "**** configure php-fpm to pass env vars ****" && \
  sed -E -i 's/^;?clear_env ?=.*$/clear_env = no/g' /etc/php84/php-fpm.d/www.conf && \
  grep -qxF 'clear_env = no' /etc/php84/php-fpm.d/www.conf || echo 'clear_env = no' >> /etc/php84/php-fpm.d/www.conf && \
  echo "**** copy grocy application ****" && \
  mkdir -p /app/www

# Copy grocy application files
COPY grocy-source/ /app/www/

RUN \
  echo "**** install composer packages ****" && \
  composer install -d /app/www --no-dev && \
  echo "**** install yarn packages ****" && \
  cd /app/www && \
  rm -f .git && \
  git init && \
  git config user.email "docker@build.local" && \
  git config user.name "Docker Build" && \
  yarn --production && \
  yarn cache clean && \
  echo "**** set permissions ****" && \
  chown -R abc:abc /app/www && \
  chmod -R 755 /app/www && \
  echo "**** cleanup ****" && \
  apk del --purge \
    build-dependencies && \
  rm -rf \
    /tmp/* \
    $HOME/.cache \
    $HOME/.composer \
    /app/www/.git

# Copy custom configurations
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /config