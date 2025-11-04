require 'rails_helper'

describe V1::Debit::CollectionsController do
  describe 'GET /debit/collections/:id/sepa', version: 1 do
    let(:record) { create(:collection) }
    let(:record_url) { "/v1/debit/collections/#{record.id}/sepa" }
    let(:record_permission) { 'debit/collection.create' }
    let(:request) { get(record_url) }

    context 'when unauthorized' do
      it_behaves_like '401 Unauthorized'
    end

    context 'when authenticated' do
      include_context 'when authenticated' do
        let(:user) { create(:user) }
      end

      it_behaves_like '403 Forbidden'
    end

    context 'when with permission' do
      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end

      context 'when on non existing collection' do
        let(:record_url) { "/v1/debit/collections/#{record.id + 1}/sepa" }

        it_behaves_like '404 Not Found'
      end

      context 'when without transactions' do
        it_behaves_like '404 Not Found'
      end

      context 'when without mandate' do
        before do
          create(:transaction, collection: record)
        end

        it_behaves_like '422 Unprocessable Content'
      end

      context 'when with transaction and mandate' do
        let(:transaction) { create(:transaction, collection: record) }

        before { create(:mandate, user: transaction.user) }

        it_behaves_like '200 OK'
      end
    end
  end
end
