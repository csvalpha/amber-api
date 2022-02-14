require 'rails_helper'

describe V1::Forum::ThreadsController do
  describe 'POST /forum/threads/:id/mark_read', version: 1 do
    let(:record) { create(:thread) }
    let(:record_url) { "/v1/forum/threads/#{record.id}/mark_read" }
    let(:record_permission) { 'forum/thread.read' }
    let(:request) { post(record_url) }

    before { create(:post, thread: record) }

    context 'when not authenticated' do
      it_behaves_like '401 Unauthorized'
    end

    context 'when authenticated' do
      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end

      before { request }

      context 'when there are no new posts' do
        it { expect(record.class.last.read?(user)).to be true }
      end

      context 'when there is a new post' do
        before { create(:post, thread: record) }

        it { expect(record.class.last.read?(user)).to be false }
      end
    end
  end
end
