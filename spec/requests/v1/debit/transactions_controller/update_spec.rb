require 'rails_helper'

describe V1::Debit::TransactionsController do
  describe 'PUT /debit/transactions/:id', version: 1 do
    let(:record) { FactoryBot.create(:transaction) }
    let(:record_url) { "/v1/debit/transactions/#{record.id}" }
    let(:record_permission) { 'debit/transaction.update' }

    it_behaves_like 'an updatable and permissible model' do
      let(:invalid_attributes) { { description: '' } }
    end
  end
end
