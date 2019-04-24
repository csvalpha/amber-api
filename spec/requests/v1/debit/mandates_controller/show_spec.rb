require 'rails_helper'

describe V1::Debit::MandatesController do
  describe 'GET /debit/mandates/:id', version: 1 do
    let(:record) { FactoryBot.create(:mandate) }
    let(:record_url) { "/v1/debit/mandates/#{record.id}" }
    let(:record_permission) { 'debit/mandate.read' }

    it_behaves_like 'a permissible model'
  end
end
