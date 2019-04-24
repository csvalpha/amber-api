require 'rails_helper'

describe V1::PollsController do
  describe 'POST /polls/:id', version: 1 do
    let(:record) { FactoryBot.create(:poll) }
    let(:record_url) { '/v1/polls' }
    let(:record_permission) { 'poll.create' }

    it_behaves_like 'a creatable and permissible model' do
      let(:valid_relationships) do
        {
          author: { data: { id: record.author_id, type: 'users' } },
          form: { data: { id: record.form_id, type: 'forms' } }
        }
      end
      let(:invalid_relationships) { { form: { data: { id: nil, type: 'forms' } } } }
    end

    context 'when authenticated' do
      let(:another_user) { FactoryBot.create(:user) }
      let(:request) do
        post(record_url,
             data: {
               id: record.id,
               type: record_type(record),
               attributes: record.attributes,
               relationships: {
                 author: { data: { id: another_user.id, type: 'users' } },
                 form: { data: { id: record.form.id, type: 'forms' } }
               }
             })
      end

      include_context 'when authenticated' do
        let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }
      end

      before { request }

      it_behaves_like '201 Created'
      it { expect(record.class.last.author).to eq(user) }
    end
  end
end
