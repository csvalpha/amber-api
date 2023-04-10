# Will try to add this to Rails itself, then we need to test it in minitest.
# Do not like to write it in Rspec now and covert it afterwards
# :nocov:
module ActionMailbox::Ingresses::Improvmx # rubocop:disable Style/ClassAndModuleChildren
  class InboundEmailsController < ActionMailbox::BaseController
    before_action :authenticate_by_password

    def create
      # Email is in the raw parameter in BASE64,
      # unless it is too large then it needs to be retrieved
      if params.key?(:raw)
        raw_email = Base64.decode64(params.require(:raw))
        ActionMailbox::InboundEmail.create_and_extract_message_id! raw_email
      else
        # Create a job to retrieve the email since it may not be available yet at the given url
        MailModerationCreationJob.set(wait: 1.minute).perform_later(params.require('raw_url'))
      end
    end
  end
end
# :nocov:
