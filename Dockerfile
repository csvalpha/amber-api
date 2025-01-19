
FROM ruby:3.2.6-alpine@sha256:671134022238c2c4a9d79dc7d1e58c909634197617901d25863642f735a27ecb

ARG BUILD_HASH='unknown'
ENV BUILD_HASH=$BUILD_HASH
ARG BUNDLE_INSTALL_EXCLUDE='development test'
EXPOSE 3000

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
RUN bundle config set without ${BUNDLE_INSTALL_EXCLUDE}
RUN bundle install
ADD . /app

CMD bundle exec puma -C config/puma.rb
