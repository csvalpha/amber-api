require 'rails_helper'

describe V1::QuickpostStatisticsController do
  describe 'GET /quickpost_statistics', version: 1 do
    let(:records) { FactoryBot.create_list(:quickpost_message, 7) }
    let(:record_url) { '/v1/quickpost_statistics' }
    let(:record_permission) { 'quickpost_message.read' }

    subject(:request) { get(record_url) }

    it_behaves_like 'a permissible model'
    it_behaves_like 'an indexable model'
  end
end
