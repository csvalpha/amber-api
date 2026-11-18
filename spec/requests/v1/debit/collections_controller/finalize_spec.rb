require 'rails_helper'

describe V1::Debit::CollectionsController do
  describe 'POST /debit/collections/:id/finalize', version: 1 do
    let(:record) { create(:collection) }
    let(:record_url) { "/v1/debit/collections/#{record.id}/finalize" }
    let(:record_permission) { 'debit/collection.create' }
    let(:request) { post(record_url) }
    let(:transaction) { create(:transaction, collection: record, amount: 50) }
    let(:declaration) { create(:declaration, :approved, user: transaction.user, amount: 20) }

    before do
      create(:mandate, user: transaction.user)
      declaration
    end

    context 'when unauthorized' do
      it_behaves_like '401 Unauthorized'
    end

    context 'when authenticated' do
      include_context 'when authenticated'

      it_behaves_like '403 Forbidden'
    end

    context 'when with permission' do
      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end

      it_behaves_like '204 No Content'
      it { expect { request }.to(change { record.reload.finalized_at }.from(nil)) }
      it { expect { request }.to(change { declaration.reload.status }.to('paid')) }
      it { expect { request }.to(change { record.transactions.count }.by(1)) }

      context 'when on non existing collection' do
        let(:record_url) { "/v1/debit/collections/#{record.id + 1}/finalize" }

        it_behaves_like '404 Not Found'
      end

      context 'when the sepa cannot be generated' do
        before { create(:transaction, collection: record) } # user without mandate

        it_behaves_like '422 Unprocessable Content'
        it { expect { request }.not_to(change { declaration.reload.status }) }
      end

      context 'when already finalized' do
        before { record.update!(finalized_at: Time.zone.now) }

        it_behaves_like '422 Unprocessable Content'
      end
    end
  end
end
