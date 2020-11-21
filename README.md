Alpha AMBER API
================
[![Build status](https://badge.buildkite.com/7bb7573780e61f69cb8d834590a0c2125ed5a5ee588fb5380e.svg)](https://buildkite.com/csv-alpha/amber-api)
[![Depfu](https://badges.depfu.com/badges/663adb8e75ff19a32ca0d866d5fe2e85/count.svg)](https://depfu.com/github/csvalpha/amber-api?project_id=7749)

## Prerequisites
* [Ruby](https://www.ruby-lang.org/en/documentation/installation/) (see `.ruby-version`, install with `rvm` or `rbenv`)
* [PostgreSQL](http://www.postgresql.org/download/) (`~> 9.5`)
* [Bundler](http://bundler.io/)
* [ImageMagick](http://imagemagick.org/script/download.php)
* [Libmagic](https://filemagic.readthedocs.io/en/latest/guide.html)
* On macOS: Xcode (or xcode-select), see [Nokogiri docs](http://www.nokogiri.org/tutorials/installing_nokogiri.html#mac_os_x) - `xcode-select --install`

## Installation
### With Docker
1. Install the [Docker Engine](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/)
2. Build the project using `docker-compose -f docker-compose.development.yml build api`. This will install the dependencies and set up the image. If dependencies are updated/added, you need to run this command again.
3. Copy the `.env.example` to `.env` and update the fields to reflect your environment. To allow the development Docker configuration on amber-ui to work, change `COMPOSE_PROJECT_NAME` to "amber_development".
4. Run the project using `docker-compose -f docker-compose.development.yml up api`.
5. Create databases and tables and run seeds with `bundle exec rails db:setup` (see tip on how to run commands in containers).

Tip: to run commands in a container, you need to find the container's ID using the `docker ps` command first. Copy the ID of the container with image "amber_development_api".
Now to run a command in that container, you can run:
```
$ docker exec <CONTAINER_ID> <COMMAND>
```
For example:
```
$ docker exec 4bde3ea072a2 bundle exec rspec
```

### Without Docker
1. Install prerequisites
2. Create a Postgres user with permission to create databases. _(optional)_
  
    - Example of doing this (it could be that you need to be the `postgres` user: do `sudo su postgres`):

        `createuser -Pd <username>`

      The username can be you own username, or any other name.

    - Configure the database by setting your environment variables according to `config/database.yml`
4. Install gems with `bundle install`
5. Create databases and tables and run seeds with `bundle exec rails db:setup`
6. Copy the `.env.example` to `.env` and update the fields to reflect your environment

## Usage
To start the server, execute:

    bundle exec rails server
    
### Credentials

Before you can start the application you will need the `master.key`. Ask a fellow developer for it, or pull it from the server via ssh.

When the `master.key` is present, you can use `bundle exec rails credentials:edit` to open the default editor on your machine to read and edit the credentials. Be informed: these are production credentials so be careful.

[Read more about Rails credentials on EngineYard.com.](https://www.engineyard.com/blog/rails-encrypted-credentials-on-rails-5.2)

Tip: you can also use one of the following commands to use an editor of your choice:

```
$ EDITOR="atom --wait" bundle exec rails credentials:edit
$ EDITOR="subl --wait" bundle exec rails credentials:edit
$ EDITOR="code --wait" bundle exec rails credentials:edit
```

## Run mailgun locally
To test the mailgun endpoint you can setup mailgun to forward mail to your local machine. To do this you should follow the following steps.

1. Install [ngrok](https://ngrok.com/download)
2. Run ngrok with `./ngrok http 3000`
3. Add a mailgun catch-all route with as action 'store and notify' to `ngrok-address`/mailgun
4. Get the [mailgun API key](https://app.mailgun.com/app/domains/csvalpha.nl)
5. Start the rails server `MAILGUN_API_KEY='key_here' bundle exec rails s`


## Run specs (tests)
The tests are written with [RSpec](http://rspec.info/), a behaviour driven test environment.

To run all tests, execute:

    bundle exec rspec

## Run specs with Guard
[Guard](https://github.com/guard/guard) is a command line tool to handle events on file system modifications. When active, it re-runs specs each time a change is noticed.

To run Guard, execute:

    bundle exec guard

## Run RuboCop (code quality)
[RuboCop](https://github.com/bbatsov/rubocop) is used to inspect the quality of the code. The rules used by RuboCop are specified in `rubocop.yml`.

To run RuboCop, execute:

    bundle exec rubocop

## Buildkite (automated testing)
Buildkite is a test service which automatically tests the application after a commit has been pushed. Buildkite will run RuboCop and RSpec (see `.buildkite/pipeline.yml`) and will fail if one of these fails.

## Deploying
See [DEPLOY.md](https://github.com/csvalpha/amber-api/blob/master/DEPLOY.md) for that.

## Permissions
See [PERMISSIONS.md](https://github.com/csvalpha/amber-api/blob/master/PERMISSIONS.md) for that.
