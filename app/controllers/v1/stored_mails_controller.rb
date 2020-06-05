class V1::StoredMailsController < V1::ApplicationController
  before_action :set_model, only: %i[accept reject]

  def accept
    authorize @model

    if @model.mailgun_mail?
      MailForwardJob.perform_later(@model.mail_alias, @model.message_url)
    else
      MailImprovmxForwardJob.perform_later(@model)
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
