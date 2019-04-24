class MailBounceMailer < ApplicationMailer
  def mail_bounced(from, to, subject, reason)
    @from = from
    @to = to
    @subject = subject
    @reason = reason
    mail to: from, subject: "#{subject} is niet afgeleverd."
  end

  def address_unknown(from, to)
    @from = from
    @to = to
    mail to: from, subject: "Mailadres #{to} bestaat niet"
  end
end
