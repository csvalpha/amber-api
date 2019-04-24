require 'rails_helper'

describe V1::Debit::CollectionsController do
  describe 'GET /debit/collections', version: 1 do
    let(:records) { FactoryBot.create_list(:collection, 3) }
    let(:record_url) { '/v1/debit/collections' }
    let(:record_permission) { 'debit/collection.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'a permissible model'
    it_behaves_like 'an indexable model'
    it_behaves_like 'a searchable model', %i[name]
  end
end
