
class ActionMailbox::Ingresses::Improvmx::InboundEmailsController < ActionMailbox::BaseController
  before_action :authenticate_by_password

  def create
    raw_base64 = params.require(:raw)
    raw = Base64.decode64(raw_base64)

    ActionMailbox::InboundEmail.create_and_extract_message_id! raw
  end
end
