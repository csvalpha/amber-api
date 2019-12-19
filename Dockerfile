FROM ruby:2.6.5-alpine

ARG BUNDLE_INSTALL_EXCLUDE='development test'

RUN apk add --update \
  bash \
  build-base \
  git \
  file-dev \
  imagemagick \
  postgresql-dev \
  tzdata \
  && rm -rf /var/cache/apk/*

RUN mkdir /app
WORKDIR /app

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install --without ${BUNDLE_INSTALL_EXCLUDE}
ADD . /app

CMD bundle exec puma -C config/puma.rb
