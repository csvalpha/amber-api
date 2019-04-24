require 'rails_helper'

describe V1::Form::ResponsesController do
  describe 'GET /form/responses', version: 1 do
    let(:records) { FactoryBot.create_list(:response, 3) }
    let(:record_url) { '/v1/form/responses' }
    let(:record_permission) { 'form/response.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'a permissible model'
    it_behaves_like 'an indexable model'
  end
end
