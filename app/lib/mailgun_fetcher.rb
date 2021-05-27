module MailgunFetcher
  class Mail
    def initialize(message_url)
      @message_url = message_url
    end

    def plain_body
      @plain_body ||= json_response['body-plain']
    end

    def sender
      @sender ||= json_response['sender']
    end

    def from
      @from ||= json_response['from']
    end

    def subject
      @subject ||= json_response['subject']
    end

    def received_at
      @received_at ||= Time.zone.parse(json_response['Date'])
    end

    def attachments
      return unless json_response['attachments']

      @attachments ||= json_response['attachments'].map do |attachment|
        {
          name: attachment['name'],
          size: attachment['size']
        }
      end
    end

    private

    def json_response
      @json_response ||= Rails.cache.fetch("json/#{@message_url}", expires_in: 3.days) do
        # See http://mailgun-documentation.readthedocs.io/en/latest/api-events.html#viewing-stored-messages
        # :nocov:
        HTTP.basic_auth(user: :api,
                        pass: Rails.application.config.x.mailgun_api_key)
            .get(@message_url).parse(:json)
        # :nocov:
      end
    end
  end
end
