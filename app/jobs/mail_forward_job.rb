require 'http'
# :nocov:
class MailForwardJob < ApplicationJob
  queue_as :mail_handlers

  def perform(stored_mail)
    to_addresses = stored_mail.mail_alias.mail_addresses
    to_addresses.each do |to_address|
      mail = stored_mail.inbound_email.mail.clone
      mail.to = to_address
      mail.cc = nil
      mail.bcc = nil
      MailForwardSendJob.perform_later(mail)
    end
  end
end
# :nocov:
