class MailAliasCreateJob < ApplicationJob
  queue_as :default

  def perform(alias_name, forward_to, domain)
    @client ||= Improvmx::Client.new

    @client.create_or_update_alias(alias_name, forward_to, domain)
  end
end
