# Will try to add this to Rails itself, then we need to test it in minitest.
# Do not like to write it in Rspec now and covert it afterwards
# :nocov:
module ActionMailbox::Ingresses::Improvmx # rubocop:disable Style/ClassAndModuleChildren
  class InboundEmailsController < ActionMailbox::BaseController
    before_action :authenticate_by_password

    def create
      ActionMailbox::InboundEmail.create_and_extract_message_id! raw_email
    end

    private

    def raw_email
      # Email is in the raw parameter in BASE64,
      # unless it is too large then it needs to be retrieved
      return Base64.decode64(params.require(:raw)) if params.key?(:raw)

      retrieve_email(params.require('raw_url'))
    end

    def retrieve_email(url) # rubocop:disable Metrics/AbcSize
      uri = URI(url)

      request = Net::HTTP::Get.new uri
      request.basic_auth 'api', Rails.application.config.x.improvmx_api_key

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(request)
      end

      logger.info response.code
      logger.info response.body

      response.body
    end
  end
end
# :nocov:
