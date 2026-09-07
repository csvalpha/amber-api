
FROM ruby:4.0.6-alpine@sha256:6ec7aeb4f3f0b67a21fb73a83fc20a4055696e64b933229f68ec805a3de38fcc

ARG BUILD_HASH='unknown'
ENV BUILD_HASH=$BUILD_HASH
ARG BUNDLE_INSTALL_EXCLUDE='development test'
EXPOSE 3000

RUN apk add --update \
  bash \
  build-base \
  git \
  file-dev \
  jpeg-dev \
  imagemagick \
  postgresql-dev \
  tzdata \
  libffi-dev \
  build-base \
  yaml-dev \
  && rm -rf /var/cache/apk/*

RUN mkdir /app
WORKDIR /app

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle config set without ${BUNDLE_INSTALL_EXCLUDE}
RUN bundle install
ADD . /app

CMD bundle exec puma -C config/puma.rb
