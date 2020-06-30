class MailAliasSyncJob < ApplicationJob
  queue_as :default

  def perform(mail_alias_ids = nil)
    mail_aliases = MailAlias.where(id: mail_alias_ids)

    mail_aliases.map { |m| create_or_update(m) }
  end

  private

  def create_or_update(mail_alias)
    update = update_alias(mail_alias)
    return if update.code == 200

    create = create_alias(mail_alias)
    return if create.code == 200

    raise "Create/Update of alias #{mail_alias} failed.
create response=#{create} update response=#{update}"
  end

  def update_alias(mail_alias)
    client.put("#{api_host}/domains/alpha.#{mail_alias.domain}/aliases/#{mail_alias.alias_name}",
               form: { forward:  forward_to(mail_alias) })
  end

  def create_alias(mail_alias)
    client.post("#{api_host}/domains/alpha.#{mail_alias.domain}/aliases/",
                form: { alias: mail_alias.alias_name, forward: forward_to(mail_alias) })
  end

  def client
    HTTP.basic_auth(user: :api, pass: Rails.application.config.x.improvmx_api_key)
  end

  def api_host
    'https://api.improvmx.com/v3'
  end

  def forward_to(mail_alias)
    return moderation_route if mail_alias.moderated?

    mail_alias.mail_addresses_str
  end

  def moderation_route
    default_options = Rails.application.config.action_mailer.default_url_options
    path = "/api/rails/action_mailbox/improvmx/inbound_emails"

    uri = URI::Generic.build(default_options.merge(path: path))
    uri.user = "api"
    uri.password = Rails.application.credentials.action_mailbox.fetch(:ingress_password)

    uri.to_s
  end
end
