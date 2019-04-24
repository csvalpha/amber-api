Mailgun.configure do |config|
  config.api_key = Rails.application.config.x.mailgun_api_key
end
