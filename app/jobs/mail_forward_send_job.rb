require 'http'
# :nocov:
class MailForwardSendJob < ApplicationJob
  queue_as :mail_handlers

  def perform(stored_mail, to_address)
    smtp = Mail::SMTP.new(ActionMailer::Base.smtp_settings)

    mail = stored_mail.inbound_email.mail

    mail.to = to_address
    mail.cc = nil
    mail.bcc = nil

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
