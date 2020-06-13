class MailAliasSyncJob < ApplicationJob
  queue_as :default

  def perform(mail_alias_id = nil)
    mail_aliases = MailAlias.where(id: mail_alias_id)

    mail_aliases.map do |m|
      create_or_update(m)
    end
  end

  private

  def create_or_update(mail_alias)
    r = update_alias(mail_alias)
    return if r == 200

    r = create_alias(mail_alias)
    return if r == 200

    raise "Create/Update of alias #{mail_alias} failed. #{r}"
  end

  def update_alias(mail_alias)
    client.put("#{api_host}/domains/alpha.#{mail_alias.domain}/aliases/#{mail_alias.alias_name}",
               form: { forward: mail_alias.mail_addresses_str })
  end

  def create_alias(mail_alias)
    client.post("#{api_host}/domains/alpha.#{mail_alias.domain}/aliases/",
                form: { alias: mail_alias.alias_name, forward: mail_alias.mail_addresses_str })
  end

  def client
    HTTP.basic_auth(user: :api, pass: Rails.application.config.x.improvmx_api_key)
  end

  def api_host
    'https://api.improvmx.com/v3'
  end
end
