class MailgunController < ApplicationController
  def webhook # rubocop:disable Metrics/AbcSize
    mail = request.params
    return head(:not_acceptable) unless verify_mailgun_signature(
      Rails.application.config.x.mailgun_validation_key,
      mail[:token], mail[:timestamp], mail[:signature]
    )

    MailReceiveJob.perform_later(mail[:recipient], mail['message-url'])
    head :ok
  end

  def bounces # rubocop:disable Metrics/AbcSize
    mail = request.params
    signature = mail[:signature]
    return head(:not_acceptable) unless verify_mailgun_signature(
      Rails.application.config.x.mailgun_validation_key,
      signature[:token], signature[:timestamp], signature[:signature]
    )

    MailBouncedJob.perform_later(mail['event-data'])
    head :ok
  end

  private

  def verify_mailgun_signature(signing_key, token, timestamp, signature)
    digest = OpenSSL::Digest::SHA256.new
    data = [timestamp, token].join
    signature == OpenSSL::HMAC.hexdigest(digest, signing_key, data)
  end
end
