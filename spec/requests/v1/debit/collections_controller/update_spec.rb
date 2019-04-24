require 'rails_helper'

describe V1::Debit::CollectionsController do
  describe 'PUT /debit/collections/:id', version: 1 do
    let(:record) { FactoryBot.create(:collection) }
    let(:record_url) { "/v1/debit/collections/#{record.id}" }

    let(:record_permission) { 'debit/collection.update' }

    it_behaves_like 'an updatable and permissible model' do
      let(:invalid_attributes) { { date: '' } }
    end

    context 'when with permission' do
      include_context 'when authenticated' do
        let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }
      end

      subject(:request) { put(record_url) }

      it { expect { request && record.reload }.not_to(change(record, :author)) }
    end
  end
end
