module V1::Debit
  class CollectionsController < V1::ApplicationController
    before_action :set_model, only: %i[sepa]

    def sepa
      authorize Debit::Collection
      return head :not_found unless @model.transactions.any?

      sepa = @model.to_sepa
      if sepa
        render xml: sepa.to_xml('pain.008.001.02')
      else
        render json: error_response, status: :unprocessable_entity
      end
    end

    private

    def set_model
      @model = model_class.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      head :not_found
    end

    def error_response
      resource = V1::Debit::CollectionResource.new(@model, {})
      errors = JSONAPI::Exceptions::ValidationErrors.new(resource).errors
      JSONAPI::ErrorsOperationResult.new(422, errors)
    end
  end
end
