class V1::StoredMailResource < V1::ApplicationResource
  extend Forwardable

  attributes :received_at, :sender, :subject, :plain_body, :attachments

  has_one :mail_alias, always_include_linkage_data: true

  def plain_body
    mail.text_part.body.decoded.force_encoding('ISO-8859-1').encode('UTF-8')
  end

  def attachments
    # :nocov:
    mail.attachments.map do |attachment|
      file = StringIO.new(attachment.to_s)

      { name: attachment.filename, size: file.size }
    end
    # :nocov:
  end

  def self.records(options = {})
    if options[:context][:action] == 'index'
      options[:includes] =
        { inbound_email: { raw_email_attachment: :blob } }
    end
    super(options)
  end

  private

  def mail
    @mail ||= @model.inbound_email.mail
  end
end
