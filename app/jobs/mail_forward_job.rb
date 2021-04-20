require 'http'

class MailForwardJob < ApplicationJob
  queue_as :mail_handlers

  def perform(mail_alias, message_url)
    # See https://documentation.mailgun.com/en/latest/api-sending.html#examples
    HTTP.basic_auth(user: :api, pass: Rails.application.config.x.mailgun_api_key)
        .post(message_url, form: { to: forward_to(mail_alias) })

    message = "#{message_url} is forwarded to #{forward_to(mail_alias)}"
    SlackMessageJob.perform_later(message, channel: 'mila-log')
  end

  private

  def forward_to(mail_alias)
    if mail_alias.moderation_type == 'open'
      mail_alias.email.gsub '@', '@alpha.'
    else
      mail_alias.mail_addresses.join(',')
    end
  end
end
