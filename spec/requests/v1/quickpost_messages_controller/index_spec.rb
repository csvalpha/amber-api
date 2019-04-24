require 'rails_helper'

describe V1::QuickpostMessagesController do
  describe 'GET /quickpost_messages', version: 1 do
    let(:records) { FactoryBot.create_list(:quickpost_message, 7) }
    let(:record_url) { '/v1/quickpost_messages' }
    let(:record_permission) { 'quickpost_message.read' }

    subject(:request) { get(record_url) }

    it_behaves_like 'a permissible model'
    it_behaves_like 'an indexable model'
    it_behaves_like 'a searchable model', %i[message]
  end
end
