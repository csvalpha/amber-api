class V1::StoredMailsController < V1::ApplicationController
  before_action :set_model, only: %i[accept reject]

  def accept
    authorize @model

    MailImprovmxForwardJob.perform_later(@model)
    MailModerationMailer.accept_email(@model.sender, @model, current_user).deliver_later

    @model.destroy
  end

  def reject
    authorize @model

    MailModerationMailer.reject_email(@model.sender, @model, current_user).deliver_later

    @model.destroy
  end
end
