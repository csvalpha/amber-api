require 'rails_helper'

describe V1::Form::ResponsesController do
  describe 'PUT /form/responses/:id', version: 1 do
    it_behaves_like 'an updatable and permissible model' do
      let(:record) { create(:response) }
      let(:record_url) { "/v1/form/responses/#{record.id}" }
      let(:record_permission) { 'form/response.update' }
      let(:valid_relationships) do
        { form: { data: { id: record.form_id, type: 'forms' } } }
      end
      let(:invalid_relationships) do
        { form: { data: { id: nil, type: 'forms' } } }
      end
    end
  end
end
