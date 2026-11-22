
FROM ruby:4.0.10-alpine@sha256:9d3416708d4f434a62bf265a865deab75d376cc1d260c71651c9fb8708dbb2e7

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
  ghostscript \
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
