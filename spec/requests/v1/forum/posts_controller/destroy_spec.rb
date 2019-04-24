require 'rails_helper'

describe V1::Forum::PostsController do
  describe 'DELETE /forum/posts/:id', version: 1 do
    let(:record) { FactoryBot.create(:post) }
    let(:record_url) { "/v1/forum/posts/#{record.id}" }
    let(:record_permission) { 'forum/post.destroy' }

    it_behaves_like 'a destroyable and permissible model'
  end
end
