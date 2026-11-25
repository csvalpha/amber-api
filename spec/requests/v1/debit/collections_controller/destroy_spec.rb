require 'rails_helper'

describe V1::Debit::CollectionsController do
  describe 'DELETE /debit/collections/:id', version: 1 do
    let(:record) { create(:collection) }
    let(:record_url) { "/v1/debit/collections/#{record.id}" }
    let(:record_permission) { 'debit/collection.destroy' }

    it_behaves_like 'a destroyable and permissible model'

    context 'when the collection is finalized' do
      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end

      let(:record) { create(:collection, finalized_at: Time.zone.now) }
      let(:request) { delete(record_url) }

      it_behaves_like '403 Forbidden'
    end
  end
end
