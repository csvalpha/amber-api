require 'rails_helper'

describe V1::QuickpostMessagesController do
  describe 'GET /quickpost_messages/:id', version: 1 do
    it_behaves_like 'a permissible model' do
      let(:record) { create(:quickpost_message) }
      let(:record_url) { "/v1/quickpost_messages/#{record.id}" }
      let(:record_permission) { 'quickpost_message.read' }
    end
  end
end
