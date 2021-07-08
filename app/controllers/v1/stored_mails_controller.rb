class V1::StoredMailsController < V1::ApplicationController
  before_action :set_model, only: %i[accept reject]
  before_action :check_improvmx_limit, only: %i[accept]

  def accept
    authorize @model

    if @model.mailgun_mail?
      MailForwardJob.perform_later(@model.mail_alias, @model.message_url)
    else
      # :nocov:
      MailImprovmxForwardJob.perform_later(@model)
      # :nocov:
    end
    MailModerationMailer.accept_email(@model.sender, @model, current_user).deliver_later

    @model.destroy

    Rails.cache.write('improvmx_send', 1, expires_in: ttl_to_midnight)
  end

  def reject
    authorize @model

    MailModerationMailer.reject_email(@model.sender, @model, current_user).deliver_later

    @model.destroy
  end

  private

  def check_improvmx_limit
    limit_error if Rails.cache.exist?('improvmx_send')
  end

  def limit_error
    render json: {
      errors: [{
        title: 'Already sent a moderated email today',
        detail: 'Already sent a moderated email today, try again tomorrow',
        code: '100',
        status: '422'
      }]
    }, status: :unprocessable_entity
  end

  def ttl_to_midnight
    24.hours.seconds - Time.zone.now.seconds_since_midnight
  end
end
