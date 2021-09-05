require 'http'
# :nocov:
class MailForwardSendJob < ApplicationJob
  queue_as :mail_handlers

  def perform(mail)
    mail.reply_to = mail.from
    mail.from = new_from(mail)
    mail.deliver!
  end

  private

  def new_from(mail)
    return mail.from if mail.from.first.include?('csvalpha.nl')

    "#{mail.from.first} <forwarding@csvalpha.nl>"
  end
end
# :nocov:
