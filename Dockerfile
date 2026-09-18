
FROM ruby:4.0.7-alpine@sha256:79bf10b28c9d98b7b3cffda01aba8190aa1c1c48513d205ec93372a0e2f010e3

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
