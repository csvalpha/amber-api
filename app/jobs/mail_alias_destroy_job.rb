class MailAliasDestroyJob < ApplicationJob
  queue_as :default

  def perform(alias_name, domain)
    @client ||= Improvmx::Client.new

    @client.delete_alias(alias_name, domain)
  end
end
