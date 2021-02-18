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
    mailgun_client.post("/domains/#{mail_alias.domain}/credentials",
                        login: mail_alias.email, password: password)
    MailSmtpMailer.enabled_email(mail_alias, password).deliver_later
  end

  def disable_smtp(mail_alias)
    mailgun_client.delete("/domains/#{mail_alias.domain}/credentials/#{mail_alias.email}")
    MailSmtpMailer.disabled_email(mail_alias).deliver_later
  end

  # :nocov:
  def mailgun_client
    return @mailgun_client unless @mailgun_client.nil?

    api_key = Rails.application.config.x.mailgun_api_key
    api_host = Rails.application.config.x.mailgun_host
    @mailgun_client = Mailgun::Client.new api_key, api_host
  end
  # :nocov:
end
