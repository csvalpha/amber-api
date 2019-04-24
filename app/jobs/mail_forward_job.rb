require 'http'

class MailForwardJob < ApplicationJob
  queue_as :mail_handlers

  def perform(mail_alias, message_url)
    # See https://documentation.mailgun.com/en/latest/api-sending.html#examples
    HTTP.basic_auth(user: :api, pass: Rails.application.config.x.mailgun_api_key)
        .post(message_url, form: { to: mail_alias.mail_addresses.join(',') })

    message = "#{message_url} is forwarded to #{mail_alias.mail_addresses.join(',')}"
    SlackMessageJob.perform_later(message, channel: 'mila-log')
  end
end
