require 'rails_helper'

describe V1::Forum::ThreadsController do
  describe 'PUT /forum/threads/:id', version: 1 do
    let(:record) { create(:thread) }
    let(:record_url) { "/v1/forum/threads/#{record.id}" }
    let(:record_permission) { 'forum/thread.update' }

    it_behaves_like 'an updatable and permissible model' do
      let(:invalid_attributes) { { title: '' } }
    end

    context 'when with permission' do
      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end

      subject(:request) { put(record_url) }

      it { expect { request && record.reload }.not_to(change(record, :author)) }
    end
  end
end
