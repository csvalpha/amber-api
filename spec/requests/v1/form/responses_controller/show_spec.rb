require 'rails_helper'

describe V1::Form::ResponsesController do
  describe 'GET /form/responses/:id', version: 1 do
    it_behaves_like 'a permissible model' do
      let(:record) { create(:response) }
      let(:record_url) { "/v1/form/responses/#{record.id}" }
      let(:record_permission) { 'form/response.read' }
    end
  end
end
