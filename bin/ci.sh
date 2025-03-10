#!/bin/bash
set -e

TYPE=$1

if [ "$TYPE" = "lint" ] || [ "$TYPE" = "" ]; then
  echo "--- :rubocop: Rubocop"
  bundle exec rubocop

  echo "--- :parcel: Brakeman"
  bundle exec brakeman -z --no-pager

  echo "--- :ruby: Bundle audit"
  gem install bundler-audit
  bundle-audit update && bundle-audit check || true
  RAILS_ENV=test bundle exec rails db:create db:environment:set db:schema:load
  # Don't check DB consistency until solved: https://github.com/trptcolin/consistency_fail/issues/42
  # bundle exec consistency_fail
fi

if [ "$TYPE" = "spec" ] || [ "$TYPE" = "" ]; then
  RAILS_ENV=test bundle exec rails db:create db:environment:set db:schema:load
  bundle exec rspec
fi
