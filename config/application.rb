require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'active_storage/engine'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Amber
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.autoload_paths << Rails.root.join('app', 'helpers')
    config.autoload_paths << Rails.root.join('app', 'paginators')

    config.i18n.default_locale = :nl

    # Required by message_bus as long as https://github.com/SamSaffron/message_bus/issues/124
    # is not fixed
    config.middleware.use ActionDispatch::Flash

    # See https://github.com/kickstarter/rack-attack#getting-started
    config.middleware.use Rack::Attack

    config.middleware.insert_before 0, Rack::Cors, debug: true, logger: (-> { Rails.logger }) do
      allow do
        origins '*'
        resource '*',
                 headers: :any,
                 methods: %i[get post delete put patch options head propfind report],
                 max_age: 0
      end
    end

    config.active_job.queue_adapter = :sidekiq
    config.time_zone = 'Europe/Amsterdam'

    config.x.slack_channel = '#monitoring'
    config.x.slack_webhook = credentials.dig(Rails.env.to_sym, :slack_webhook) || ''

    config.x.mailgun_api_key = credentials.dig(Rails.env.to_sym, :mailgun_api_key)
    config.x.mailgun_validation_key = credentials.dig(Rails.env.to_sym, :mailgun_validation_key)
    config.x.mailgun_host = 'api.eu.mailgun.net'
    config.x.mail_domains = %w[csvalpha.nl societeitflux.nl sandbox86621.eu.mailgun.org]

    config.x.sentry_dsn = credentials.dig(Rails.env.to_sym, :sentry_dsn)

    config.x.camo_host = credentials.dig(Rails.env.to_sym, :camo_host)
    config.x.camo_key = credentials.dig(Rails.env.to_sym, :camo_key)

    config.x.daily_verse_user = credentials.dig(Rails.env.to_sym, :daily_verse_user)
    config.x.daily_verse_password = credentials.dig(Rails.env.to_sym, :daily_verse_password)
  end
end
