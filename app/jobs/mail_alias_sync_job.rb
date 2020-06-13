class MailAliasSyncJob < ApplicationJob
  queue_as :default

  def perform(mail_alias_ids = nil)
    mail_aliases = MailAlias.where(id: mail_alias_ids)

    mail_aliases.map { |m| create_or_update(m) }
  end

  private

  def create_or_update(mail_alias)
    r = update_alias(mail_alias) || create_alias(mail_alias)

    raise "Create/Update of alias #{mail_alias} failed. #{r}" unless r
  end

  def update_alias(mail_alias)
    r = client.put(
      "#{api_host}/domains/alpha.#{mail_alias.domain}/aliases/#{mail_alias.alias_name}",
      form: { forward: mail_alias.mail_addresses_str }
    )

    r == 200
  end

  def create_alias(mail_alias)
    r = client.post("#{api_host}/domains/alpha.#{mail_alias.domain}/aliases/",
                    form: { alias: mail_alias.alias_name, forward: mail_alias.mail_addresses_str })

    r == 200
  end

  def client
    HTTP.basic_auth(user: :api, pass: Rails.application.config.x.improvmx_api_key)
  end

  def api_host
    'https://api.improvmx.com/v3'
  end
end
