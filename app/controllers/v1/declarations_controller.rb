class V1::DeclarationsController < V1::ApplicationController
  before_action :set_model, only: %i[approve reject receipt pdf]

  def approve
    authorize @model
    return render_model_errors unless @model.approve!(current_user)

    DeclarationMailer.approved_email(@model).deliver_later
    head :no_content
  end

  def reject
    authorize @model
    return render_model_errors unless @model.reject!(params[:rejection_reason])

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
