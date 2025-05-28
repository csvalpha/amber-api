
FROM ruby:3.4.4-alpine@sha256:5bdfa2312f3f0bc9bd077e954c943652155a093db228af978873ff92389300d3

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
