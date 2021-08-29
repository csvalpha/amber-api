class V1::StoredMailsController < V1::ApplicationController
  before_action :set_model, only: %i[accept reject]

  def accept
    authorize @model

    if @model.mailgun_mail?
      MailForwardJob.perform_later(@model.mail_alias, @model.message_url)
    else
      # :nocov:
      to_addresses = @model.mail_alias.mail_addresses
      to_addresses.each { |to_address|
        mail = @model.inbound_email.mail.clone
        mail.to = to_address
        mail.cc = nil
        mail.bcc = nil
        MailImprovmxForwardJob.perform_later(mail)
      }
      # :nocov:
    end
    MailModerationMailer.accept_email(@model.sender, @model, current_user).deliver_later

    @model.destroy
  end

  def reject
    authorize @model

    MailModerationMailer.reject_email(@model.sender, @model, current_user).deliver_later

    @model.destroy
  end
end
