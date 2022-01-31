require 'rails_helper'

describe V1::Forum::PostsController do
  describe 'POST /forum/posts', version: 1 do
    it_behaves_like 'a creatable and permissible model' do
      let(:record) { create(:post) }
      let(:record_url) { '/v1/forum/posts' }
      let(:record_permission) { 'forum/post.create' }
      let(:invalid_attributes) { { message: '' } }
      let(:valid_relationships) do
        {
          author: { data: { id: record.author_id, type: 'users' } },
          thread: { data: { id: record.thread_id, type: 'threads' } }
        }
      end
      let(:invalid_relationships) do
        {
          author: { data: nil },
          thread: { data: { id: record.thread_id, type: 'threads' } }
        }
      end
    end
  end
end
