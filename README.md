Alpha AMBER API
================
[![Continuous Integration](https://github.com/csvalpha/amber-api/actions/workflows/continuous-integration.yml/badge.svg)](https://github.com/csvalpha/amber-api/actions/workflows/continuous-integration.yml)
[![Continuous Delivery](https://github.com/csvalpha/amber-api/actions/workflows/continuous-delivery.yml/badge.svg)](https://github.com/csvalpha/amber-api/actions/workflows/continuous-delivery.yml)

## Prerequisites
If you're going to run the project with Docker, you only need to install the following prerequisites:
* [Docker Engine](https://docs.docker.com/get-docker/) 
* [Docker Compose](https://docs.docker.com/compose/install/)

Otherwise, you need the following prerequisites installed:
* [Ruby](https://www.ruby-lang.org/en/documentation/installation/) (see `.ruby-version`, install with `rvm` or `rbenv`)
* [PostgreSQL](http://www.postgresql.org/download/) (`~> 9.5`)
* [Bundler](http://bundler.io/)
* [ImageMagick](http://imagemagick.org/script/download.php)
* [Libmagic](https://filemagic.readthedocs.io/en/latest/guide.html)
* On macOS: Xcode (or xcode-select), see [Nokogiri docs](http://www.nokogiri.org/tutorials/installing_nokogiri.html#mac_os_x) - `xcode-select --install`

## Installation
### With Docker
1. Build the project using `docker-compose -f docker-compose.development.yml build api`. This will install the dependencies and set up the image. If dependencies are updated/added, you need to run this command again.
2. Copy the `.env.example` to `.env` and update the fields to reflect your environment. To allow the development Docker configuration on amber-ui to work, change `COMPOSE_PROJECT_NAME` to "amber_development".
3. Create databases and tables and run seeds with `bundle exec rails db:setup` (see tip on how to run commands in the container).

Tip: to run commands in the container, you can run the following:
```
$ docker-compose -f docker-compose.development.yml run api <COMMAND>
```
For example:
```
$ docker-compose -f docker-compose.development.yml run api bundle exec rspec
```

### Without Docker
1. Create a Postgres user with permission to create databases. _(optional)_
  
    - Example of doing this (it could be that you need to be the `postgres` user: do `sudo su postgres`):

        `createuser -Pd <username>`

      The username can be you own username, or any other name.

    - Configure the database by setting your environment variables according to `config/database.yml`
2. Install gems with `bundle install`
3. Create databases and tables and run seeds with `bundle exec rails db:setup`
4. Copy the `.env.example` to `.env` and update the fields to reflect your environment

## Usage
If you're using Docker, you can run the project by using `docker-compose -f docker-compose.development.yml up api`, otherwise run `bundle exec rails server`.
     
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

## Run ImprovMX locally
To test the ImprovMX endpoint you can setup ImprovMX to forward mail to your local machine. To do this you should follow the following steps.

1. Install [ngrok](https://ngrok.com/download)
2. Run ngrok with `./ngrok http 3000`
3. Add an ImprovMX email address that forwards to `https://actionmailbox:<action_mailbox-ingress-password>@<ngrok-address>/rails/action_mailbox/improvmx/inbound_emails`
4. Add the `NGROK_HOST` to your `.env` file
5. Start the rails server


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

## GitHub Actions (automated testing)
GitHub Actions is a CI/CD service which automatically tests the application after a commit has been pushed. GitHub Actions will run RuboCop and RSpec (see `.github/workflows/continuous-integration.yml`) and will fail if one of these fails.

## Deploying
See [DEPLOY.md](https://github.com/csvalpha/amber-api/blob/master/DEPLOY.md) for that.

## Permissions
See [PERMISSIONS.md](https://github.com/csvalpha/amber-api/blob/master/PERMISSIONS.md) for that.
