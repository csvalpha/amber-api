class V1::StoredMailResource < V1::ApplicationResource
  extend Forwardable

  attributes :message_url, :received_at, :sender, :subject, :plain_body, :attachments

  has_one :mail_alias, always_include_linkage_data: true

  def_delegators :mail, :plain_body, :attachments

  def self.searchable_fields
    %i[sender subject]
  end

  private

  def mail
    @mail ||= MailgunFetcher::Mail.new(message_url)
  end
end
