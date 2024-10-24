class MailAliasSyncJob < ApplicationJob
  queue_as :default

  def perform(mail_alias_ids = nil)
    @client ||= Improvmx::Client.new

    mail_aliases = MailAlias.with_deleted.where(id: mail_alias_ids)
    sync(mail_aliases)
  end

  private

  def sync(aliases)
    @retry = 0
    aliases.map do |m|
      sync_alias(m)
    rescue Improvmx::RateLimitError => e
      raise e unless @retry < 5

      sleep e.wait_seconds
      @retry += 1
      retry
    end
  end

  def sync_alias(mail_alias)
    if mail_alias.deleted? || mail_alias.mail_addresses.empty?
      @client.delete_alias(mail_alias.alias_name, mail_alias.domain)
    else
      @client.create_or_update_alias(mail_alias.alias_name, forward_to(mail_alias),
                                     mail_alias.domain)
    end
  end

  def forward_to(mail_alias)
    return moderation_route if mail_alias.moderated?

    mail_alias.mail_addresses
  end

  def moderation_route
    default_options = Rails.application.config.action_mailer.default_url_options
    path = '/api/rails/action_mailbox/improvmx/inbound_emails'

    uri = URI::Generic.build(default_options.merge(path: path))
    uri.user = 'actionmailbox'
    uri.password = Rails.application.credentials.action_mailbox.fetch(:ingress_password)

    uri.to_s
  end
end
