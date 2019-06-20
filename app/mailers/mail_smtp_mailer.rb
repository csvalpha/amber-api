class MailSMTPMailer < ApplicationMailer
  def enabled_email(mail_alias, password)
    @mail_alias = mail_alias
    @password = password
    mail to: mail_alias.email, subject: "SMTP account voor #{mail_alias.email} aangemaakt"
  end

  def disabled_email(mail_alias)
    @mail_alias = mail_alias
    mail to: mail_alias.email, subject: "SMTP account voor #{mail_alias.email} opgeheven"
  end
end
