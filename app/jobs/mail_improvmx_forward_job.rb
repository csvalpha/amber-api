require 'http'
BATCH_SIZE=10
# TODO: Rename after mailgun has been removed
class MailImprovmxForwardJob < ApplicationJob
  queue_as :mail_handlers

  def perform(stored_mail)
    smtp = Mail::SMTP.new({address: 'smtp.improvmx.com', port: '587',
                           user_name: 'no-reply@hetkrat.nl', password: 'LbislyyRdY49'}) # TODO: use default SMTP as soon as we use ImprovMX as default
    mail = stored_mail.inbound_email.mail
    mail.to = nil

    to_addresses = stored_mail.mail_alias.mail_addresses
    while to_addresses.any?
      mail.reply_to = mail.from
      mail.from = new_from(mail)
      mail.bcc = to_addresses.pop(BATCH_SIZE)

      smtp.deliver!(mail)
    end


    # message = "IMPROVMX: #{message_url} is forwarded to #{mail_alias.mail_addresses.join(',')}"
    # SlackMessageJob.perform_later(message, channel: 'mila-log')
  end

  private

  def new_from(mail)
    return mail.from if mail.from.first.include?("hetkrat.nl")

    "#{mail.from.first} <forwarding@hetkrat.nl>"
  end
end
