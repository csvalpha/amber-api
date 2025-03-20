module V1::Debit
  class CollectionsController < V1::ApplicationController
    before_action :set_model, only: %i[sepa]

    def sepa
      authorize Debit::Collection
      return head :not_found unless @model.transactions.any?

      sepa_files = @model.to_sepa
      return render json: error_response, status: unprocessable_entity if sepa_files.empty?

      send_compressed_sepa_files(sepa_files)
    end

    private

    def set_model
      @model = model_class.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      head :not_found
    end

    def send_compressed_sepa_files(sepa_files)
      date_string = Time.zone.today.strftime('%Y-%m-%d')

      compressed_filestream = Zip::OutputStream.write_buffer do |zip|
        sepa_files.each_with_index do |sepa, index|
          zip.put_next_entry("sepa_#{date_string}_deel_#{index + 1}.xml")
          zip.write sepa.to_xml('pain.008.001.02')
        end
      end

      send_data compressed_filestream.string, type: 'application/zip'
    end

    def error_response
      resource = V1::Debit::CollectionResource.new(@model, {})
      errors = JSONAPI::Exceptions::ValidationErrors.new(resource).errors
      JSONAPI::ErrorsOperationResult.new(422, errors)
    end
  end
end
