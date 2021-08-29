require 'http'
# TODO: Rename after mailgun has been removed, and increase test coverage
# :nocov:
class MailImprovmxForwardJob < ApplicationJob
  queue_as :mail_handlers

  def perform(mail)
    # TODO: use default SMTP as soon as we use ImprovMX as default
    smtp = Mail::SMTP.new({ address: 'smtp.improvmx.com', port: '587',
                            user_name: Rails.application.config.x.smtp_username,
                            password: Rails.application.config.x.smtp_password })

    mail.reply_to = mail.from
    mail.from = new_from(mail)
    smtp.deliver!(mail)
  end

  private

  def new_from(mail)
    return mail.from if mail.from.first.include?('csvalpha.nl')

    "#{mail.from.first} <forwarding@csvalpha.nl>"
  end
end
# :nocov:
