require 'http'

class MailForwardJob < ApplicationJob
  queue_as :mail_handlers

  def perform(mail_alias, message_url)
    # See https://documentation.mailgun.com/en/latest/api-sending.html#examples
    forward_to = mail_alias.email.gsub! '@', '@alpha.'

    HTTP.basic_auth(user: :api, pass: Rails.application.config.x.mailgun_api_key)
        .post(message_url, form: { to: forward_to })

    message = "#{message_url} is forwarded to #{forward_to}"
    SlackMessageJob.perform_later(message, channel: 'mila-log')
  end
end
