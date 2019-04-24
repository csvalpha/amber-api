require 'rails_helper'

describe V1::PollsController do
  describe 'PUT /polls/:id', version: 1 do
    let(:record) { FactoryBot.create(:poll) }
    let(:record_url) { "/v1/polls/#{record.id}" }
    let(:record_permission) { 'poll.update' }

    it_behaves_like 'an updatable and permissible model' do
      let(:invalid_relationships) { { form: { data: { id: nil, type: 'forms' } } } }
    end

    context 'when with permission' do
      include_context 'when authenticated' do
        let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }
      end

      subject(:request) do
        put(record_url, data: {
              id: record.id,
              type: record_type(record)
            })
      end

      it { expect { request && record.reload }.not_to(change(record, :author)) }
    end
  end
end
