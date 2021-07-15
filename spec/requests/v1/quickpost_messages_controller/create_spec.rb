require 'rails_helper'

describe V1::QuickpostMessagesController do
  describe 'POST /quickpost_messages', version: 1 do
    let(:record) { FactoryBot.build_stubbed(:quickpost_message) }
    let(:record_url) { '/v1/quickpost_messages' }
    let(:record_permission) { 'quickpost_message.create' }

    it_behaves_like 'a creatable and permissible model' do
      let(:invalid_attributes) { { message: '' } }
    end

    it_behaves_like 'a creatable model with author'
  end
end
