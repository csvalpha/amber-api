class V1::DeclarationsController < V1::ApplicationController
  before_action :set_model, only: %i[approve reject receipt pdf]

  # The decision is taken under a row lock (with_lock reloads the record), so two concurrent
  # decisions cannot both pass the pending check in the policy
  def approve
    approved = @model.with_lock do
      authorize @model
      @model.approve!(current_user)
    end
    return render_model_errors unless approved

    DeclarationMailer.approved_email(@model).deliver_later
    head :no_content
  end

  def reject
    rejected = @model.with_lock do
      authorize @model
      @model.reject!(params[:rejection_reason])
    end
    return render_model_errors unless rejected

    DeclarationMailer.rejected_email(@model).deliver_later
    head :no_content
  end

  def receipt
    authorize @model
    return head :not_found if @model.receipt.blank?

    send_file @model.receipt.path, type: @model.receipt.content_type, disposition: 'inline'
  end

  def pdf
    authorize @model

    pdf = DeclarationPdf.new(@model)
    send_data pdf.render, filename: pdf.filename, type: 'application/pdf'
  end

  private

  def render_model_errors
    resource = V1::DeclarationResource.new(@model, context)
    errors = JSONAPI::Exceptions::ValidationErrors.new(resource).errors
    render json: JSONAPI::ErrorsOperationResult.new(422, errors), status: :unprocessable_entity
  end
end
