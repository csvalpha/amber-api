require 'rails_helper'

describe V1::QuickpostMessagesController do
  describe 'DELETE /quickpost_messages/:id', version: 1 do
    it_behaves_like 'a destroyable and permissible model' do
      let(:record) { create(:quickpost_message) }
      let(:record_url) { "/v1/quickpost_messages/#{record.id}" }
      let(:record_permission) { 'quickpost_message.destroy' }
    end
  end
end
