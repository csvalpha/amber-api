class MailSmtpMailer < ApplicationMailer
  # Mail to notify the user of their new SMTP options
  def enabled_email(mail_alias, password)
    @mail_alias = mail_alias
    @password = password
    mail bcc: mail_alias.mail_addresses,
         subject: "Je kunt nu mail versturen vanaf #{mail_alias.email}!"
  end

  # Notify mail management that an account has been granted SMTP
  # This one is different from the one to the user
  #   since we do not want to send the password to mail management
  def notify_management_enable_email(mail_alias)
    @mail_alias = mail_alias
    mail to: Rails.application.config.x.mailbeheer_email,
         subject: "SMTP account voor #{mail_alias.email} aangemaakt"
  end

  # Mail to notify the user and mail management that their SMTP is removed
  def disabled_email(mail_alias)
    @mail_alias = mail_alias
    mail to: Rails.application.config.x.mailbeheer_email, bcc: mail_alias.mail_addresses,
         subject: "SMTP account voor #{mail_alias.email} opgeheven"
  end
end
