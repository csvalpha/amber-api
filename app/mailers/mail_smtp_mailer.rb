class MailSMTPMailer < ApplicationMailer
  def enabled_email(mail_alias, password)
    @mail_alias = mail_alias
    @password = password
    mail cc: 'mailbeheer@csvalpha.nl', bcc: mail_alias.mail_addresses,
         subject: "SMTP account voor #{mail_alias.email} aangemaakt"
  end

  def disabled_email(mail_alias)
    @mail_alias = mail_alias
    mail cc: 'mailbeheer@csvalpha.nl', bcc: mail_alias.mail_addresses,
         subject: "SMTP account voor #{mail_alias.email} opgeheven"
  end
end
