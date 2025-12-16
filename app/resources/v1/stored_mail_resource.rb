# frozen_string_literal: true

class V1::StoredMailResource < V1::ApplicationResource
  self.model = StoredMail

  attribute :received_at, :datetime, writable: false
  attribute :sender, :string, writable: false
  attribute :subject, :string, writable: false
  attribute :plain_body, :string, writable: false do
    mail.text_part.body.decoded.force_encoding('ISO-8859-1').encode('UTF-8')
  end
  attribute :attachments, :array, writable: false do
    # :nocov:
    mail.attachments.map do |attachment|
      file = StringIO.new(attachment.to_s)
      { name: attachment.filename, size: file.size }
    end
    # :nocov:
  end

  has_one :mail_alias

  def base_scope
    scope = super
    if context&.dig(:action) == 'index'
      scope = scope.includes(inbound_email: { raw_email_attachment: :blob })
    end
    scope
  end

  private

  def mail
    @mail ||= @object.inbound_email.mail
  end
end
