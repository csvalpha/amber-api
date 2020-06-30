require 'rails_helper'

describe V1::Forum::ThreadsController do
  describe 'POST /forum/threads/:id/mark_read', version: 1 do
    let(:record) { FactoryBot.create(:thread) }
    let(:record_url) { "/v1/forum/threads/#{record.id}/mark_read" }
    let(:record_permission) { 'forum/thread.read' }
    let(:request) { post(record_url) }

    context 'when not authenticated' do
      it_behaves_like '401 Unauthorized'
    end

    context 'when authenticated' do
      include_context 'when authenticated'

      context 'when with permission' do
        let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }

        it { expect(record.class.last.read(user)).to be true }
      end
    end
  end
end
