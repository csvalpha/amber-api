require_relative 'boot'
require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
# require "action_view/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Amber
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.i18n.default_locale = :nl

    # Required by message_bus as long as https://github.com/SamSaffron/message_bus/issues/124
    # is not fixed
    config.middleware.use ActionDispatch::Flash

    # See https://guides.rubyonrails.org/api_app.html#using-session-middlewares
    config.session_store :cookie_store, key: '_interslice_session'
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use config.session_store, config.session_options

    # See https://github.com/kickstarter/rack-attack#getting-started
    config.middleware.use Rack::Attack

    config.middleware.insert_before 0, Rack::Cors, debug: true, logger: -> { Rails.logger } do
      allow do
        origins '*'
        resource '*',
                 headers: :any,
                 methods: %i[get post delete put patch options head propfind report],
                 max_age: 0
      end
    end

    config.action_mailbox.ingress = :improvmx
    config.action_mailbox.incinerate_after = 7.days

    config.active_job.queue_adapter = :sidekiq
    config.time_zone = 'Europe/Amsterdam'

    config.x.mail_domains = %w[csvalpha.nl societeitflux.nl]
    config.x.improvmx_api_key = credentials.dig(Rails.env.to_sym, :improvmx_api_key)
    config.x.smtp_username = credentials.dig(:production, :smtp_username)
    config.x.smtp_password = credentials.dig(:production, :smtp_password)

    config.x.sentry_dsn = credentials.dig(Rails.env.to_sym, :sentry_dsn)

    config.x.camo_host = credentials.dig(Rails.env.to_sym, :camo_host)
    config.x.camo_key = credentials.dig(Rails.env.to_sym, :camo_key)

    config.x.daily_verse_user = credentials.dig(Rails.env.to_sym, :daily_verse_user)
    config.x.daily_verse_password = credentials.dig(Rails.env.to_sym, :daily_verse_password)

    config.x.google_api_key = credentials.dig(Rails.env.to_sym, :google_api_key)

    config.x.healthcheck_ids = credentials.dig(Rails.env.to_sym, :healthcheck_ids)

    config.x.noreply_email = ENV.fetch('NOREPLY_EMAIL', 'no-reply@csvalpha.nl')
    config.x.ict_email = ENV.fetch('ICT_EMAIL', 'ict@csvalpha.nl')
    config.x.privacy_email = ENV.fetch('PRIVACY_EMAIL', 'privacy@csvalpha.nl')
    config.x.mailbeheer_email = ENV.fetch('MAILADMIN_EMAIL', 'mailbeheer@csvalpha.nl')
  end
end
