require 'rails_helper'

describe V1::Debit::CollectionsController do
  describe 'DELETE /debit/collections/:id', version: 1 do
    let(:record) { FactoryBot.create(:collection) }
    let(:record_url) { "/v1/debit/collections/#{record.id}" }
    let(:record_permission) { 'debit/collection.destroy' }

    it_behaves_like 'a destroyable and permissible model'
  end
end
