class SmtpJob < ApplicationJob
  queue_as :default

  def perform(mail_alias, enable)
    if enable
      enable_smtp(mail_alias)
    else
      disable_smtp(mail_alias)
    end
  end

  private

  def enable_smtp(mail_alias)
    password = SecureRandom.hex(16)
    puts mail_alias.email
    client.create_smtp(mail_alias.alias_name, password, mail_alias.domain)

    MailSmtpMailer.enabled_email(mail_alias, password).deliver_later
    MailSmtpMailer.notify_management_enable_email(mail_alias).deliver_later
  end

  def disable_smtp(mail_alias)
    client.delete_smtp(mail_alias.alias_name, mail_alias.domain)
    MailSmtpMailer.disabled_email(mail_alias).deliver_later
  end

  # :nocov:
  def client
    @client ||= Improvmx::Client.new
  end
  # :nocov:
end
