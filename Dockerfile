
FROM ruby:3.4.6-alpine@sha256:d594d5debffa14c591c4fe03b9d0d79cdc28f30d594f47be748e642746057fec

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
