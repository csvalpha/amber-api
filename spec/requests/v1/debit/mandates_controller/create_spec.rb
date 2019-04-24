require 'rails_helper'

describe V1::Debit::MandatesController do
  describe 'POST /debit/mandates', version: 1 do
    let(:record) { FactoryBot.create(:mandate) }
    let(:record_url) { '/v1/debit/mandates' }
    let(:record_permission) { 'debit/mandate.create' }

    it_behaves_like 'a creatable and permissible model' do
      let(:invalid_attributes) { { start_date: '' } }
      let(:valid_relationships) do
        {
          user: { data: { id: record.user_id, type: 'users' } }
        }
      end
    end
  end
end
