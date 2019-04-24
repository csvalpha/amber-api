require 'rails_helper'

describe V1::Debit::TransactionsController do
  describe 'GET /debit/transactions/:id', version: 1 do
    let(:record) { FactoryBot.create(:transaction) }
    let(:record_url) { "/v1/debit/transactions/#{record.id}" }
    let(:record_permission) { 'debit/transaction.read' }

    it_behaves_like 'a permissible model'
  end
end
