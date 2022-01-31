require 'rails_helper'

describe V1::Debit::TransactionsController do
  describe 'POST /debit/transactions', version: 1 do
    let(:record) { create(:transaction) }
    let(:record_url) { '/v1/debit/transactions' }
    let(:record_permission) { 'debit/transaction.create' }

    subject(:request) do
      post(record_url,
           data: {
             id: record.id,
             type: record_type(record),
             attributes: record.attributes
           })
    end

    it_behaves_like 'a creatable and permissible model' do
      let(:invalid_attributes) { { description: '' } }
      let(:valid_relationships) do
        { user: { data: { id: record.user_id, type: 'users' } },
          collection: { data: { id: record.collection_id, type: 'collections' } } }
      end
    end
  end
end
