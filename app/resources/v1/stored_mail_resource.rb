class V1::StoredMailResource < V1::ApplicationResource
  extend Forwardable

  attributes :message_url, :received_at, :sender, :subject, :plain_body, :attachments

  has_one :mail_alias, always_include_linkage_data: true

  # :nocov:
  def plain_body
    return mail.plain_body if @model.mailgun_mail?

    mail.text_part.body.decoded.force_encoding('ISO-8859-1').encode('UTF-8')
  end

  def attachments
    return mail.attachments if @model.mailgun_mail?

    mail.attachments.map do |attachment|
      file = StringIO.new(attachment.to_s)

      { name: attachment.filename, size: file.size }
    end
  end
  # :nocov:

  def self.searchable_fields
    %i[sender subject]
  end

  private

  def mail
    return @mail ||= MailgunFetcher::Mail.new(message_url) if @model.mailgun_mail?

    # :nocov:
    @mail ||= @model.inbound_email.mail
    # :nocov:
  end
end
