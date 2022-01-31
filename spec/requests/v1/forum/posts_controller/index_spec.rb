require 'rails_helper'

describe V1::Forum::PostsController do
  describe 'GET /forum/posts', version: 1 do
    let(:records) { create_list(:post, 3) }
    let(:record_url) { '/v1/forum/posts' }
    let(:record_permission) { 'forum/post.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'a permissible model'
    it_behaves_like 'an indexable model'
    it_behaves_like 'a searchable model', %i[message]

    describe 'when authenticated' do
      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end
      it_behaves_like 'a filterable model for', [:thread]
    end
  end
end
