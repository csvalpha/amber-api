require 'rails_helper'

describe V1::QuickpostMessagesController do
  describe 'POST /quickpost_messages', version: 1 do
    let(:record) { FactoryBot.build_stubbed(:quickpost_message) }
    let(:record_url) { '/v1/quickpost_messages' }
    let(:record_permission) { 'quickpost_message.create' }

    it_behaves_like 'a creatable and permissible model' do
      let(:invalid_attributes) { { message: '' } }
    end

    context 'when authenticated' do
      let(:another_user) { FactoryBot.create(:user) }
      let(:valid_request) do
        post(record_url,
             data: {
               id: record.id,
               type: record_type(record),
               attributes: record.attributes,
               relationships: {
                 author: { data: { id: another_user.id } }
               }
             })
      end

      include_context 'when authenticated' do
        let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }
      end

      before { valid_request }

      it { expect(record.class.last.author).to eq(user) }
    end
  end
end
