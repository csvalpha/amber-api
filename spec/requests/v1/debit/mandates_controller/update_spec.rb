require 'rails_helper'

describe V1::Debit::MandatesController do
  describe 'PUT /debit/mandates/:id', version: 1 do
    let(:record) { FactoryBot.create(:mandate) }
    let(:record_url) { "/v1/debit/mandates/#{record.id}" }

    let(:record_permission) { 'debit/mandate.update' }

    it_behaves_like 'an updatable and permissible model' do
      let(:invalid_attributes) { { start_date: '' } }
    end
  end
end
