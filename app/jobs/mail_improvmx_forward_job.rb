require 'http'
BATCH_SIZE=10
# TODO: Rename after mailgun has been removed
class MailImprovmxForwardJob < ApplicationJob
  queue_as :mail_handlers

  def perform(stored_mail)
    smtp = Mail::SMTP.new({address: 'smtp.improvmx.com', port: '587',
                           user_name: 'no-reply@hetkrat.nl', password: '630SDtTBYMcM'})
    mail = stored_mail.inbound_email.mail

    to_addresses = stored_mail.mail_alias.mail_addresses
    while to_addresses.any?
      mail.from = "forwarding@hetkrat.nl" # TODO Do something smart, such as when it is from an adresses owned by us persists otherwise add the name and send from forwarding@
      mail.bcc = to_addresses.pop(BATCH_SIZE)

      smtp.deliver!(mail)
    end


    # message = "IMPROVMX: #{message_url} is forwarded to #{mail_alias.mail_addresses.join(',')}"
    # SlackMessageJob.perform_later(message, channel: 'mila-log')
  end
end
