require 'http'
# :nocov:
class MailForwardJob < ApplicationJob
  queue_as :mail_handlers

  def perform(stored_mail)
    to_addresses = stored_mail.mail_alias.mail_addresses
    to_addresses.each do |to_address|
      # Don't send the mail to the sender
      next if stored_mail.inbound_email.mail.from.include? to_address

      MailForwardSendJob.perform_later(stored_mail, to_address)
    end
  end
end
# :nocov:
