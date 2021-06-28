require 'http'
BATCH_SIZE = 10
# TODO: Rename after mailgun has been removed, and increase test coverage
# :nocov:
class MailImprovmxForwardJob < ApplicationJob
  queue_as :mail_handlers

  def perform(stored_mail) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    # TODO: use default SMTP as soon as we use ImprovMX as default
    smtp = Mail::SMTP.new({ address: 'smtp.improvmx.com', port: '587',
                            user_name: Rails.application.config.x.smtp_username,
                            password: Rails.application.config.x.smtp_password })
    mail = stored_mail.inbound_email.mail
    mail.to = nil
    mail.reply_to = mail.from
    mail.from = new_from(mail)

    to_addresses = stored_mail.mail_alias.mail_addresses
    while to_addresses.any?
      mail.bcc = to_addresses.pop(BATCH_SIZE)

      smtp.deliver!(mail)
    end
  end

  private

  def new_from(mail)
    return mail.from if mail.from.first.include?('csvalpha.nl')

    "#{mail.from.first} <forwarding@csvalpha.nl>"
  end
end
# :nocov:
