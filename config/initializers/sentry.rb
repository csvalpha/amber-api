Raven.configure do |config|
  config.dsn = Rails.application.config.x.sentry_dsn
  config.environments = %w[production staging]
  config.release = ENV['BUILD_HASH']
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)

  config.async = lambda { |event|
    SentryJob.perform_later(event.to_hash)
  }
end
