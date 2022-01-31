require 'rails_helper'

describe V1::Debit::CollectionsController do
  describe 'GET /debit/collections/:id', version: 1 do
    let(:record) { create(:collection) }
    let(:record_url) { "/v1/debit/collections/#{record.id}" }
    let(:record_permission) { 'debit/collection.read' }

    it_behaves_like 'a permissible model'
  end
end
