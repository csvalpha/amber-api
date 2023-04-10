class MailModerationCreationJob < ApplicationJob
  queue_as :mail_handlers

  def perform(raw_url)
    ActionMailbox::InboundEmail.create_and_extract_message_id! retrieve_email(raw_url)
  end

  private

  def retrieve_email(url) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    uri = URI(url)

    request = Net::HTTP::Get.new uri
    request.basic_auth 'api', Rails.application.config.x.improvmx_api_key

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    if response.is_a? Net::HTTPSuccess
      response.body
    else
      raise "Improvmx API returned #{response.code} #{response.message}"
    end
  end
end
