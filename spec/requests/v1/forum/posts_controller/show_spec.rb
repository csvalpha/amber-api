require 'rails_helper'

describe V1::Forum::PostsController do
  describe 'GET /forum/posts/:id', version: 1 do
    it_behaves_like 'a permissible model' do
      let(:record) { FactoryBot.create(:post) }
      let(:record_url) { "/v1/forum/posts/#{record.id}" }
      let(:record_permission) { 'forum/post.read' }
      let(:valid_request) { get(record_url) }
    end
  end
end
