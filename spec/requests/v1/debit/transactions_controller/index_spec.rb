require 'rails_helper'

describe V1::Debit::TransactionsController do
  describe 'GET /debit/transactions', version: 1 do
    let(:records) { create_list(:transaction, 3) }
    let(:record_url) { '/v1/debit/transactions' }
    let(:record_permission) { 'debit/transaction.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'an indexable model'
    it_behaves_like 'a searchable model', %i[description]

    describe 'user' do
      context 'when authenticated' do
        include_context 'when authenticated' do
          let(:user) { records.first.user }
        end

        it_behaves_like '200 OK'
        it { expect(json_object_ids).to contain_exactly(records.first.id) }
      end

      context 'when with permission' do
        include_context 'when authenticated' do
          let(:user) do
            create(:user, user_permission_list: ['debit/transaction.read'])
          end
        end
        before { records }

        it_behaves_like '200 OK'
        it { expect(json_object_ids).to match_array(records.map(&:id)) }
      end
    end

    describe 'when authenticated' do
      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end
      it_behaves_like 'a filterable model for', [:collection]
    end
  end
end
