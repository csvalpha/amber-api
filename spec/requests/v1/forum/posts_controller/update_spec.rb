require 'rails_helper'

describe V1::Forum::PostsController do
  describe 'PUT /forum/posts/:id', version: 1 do
    let(:record) { FactoryBot.create(:post) }
    let(:record_url) { "/v1/forum/posts/#{record.id}" }
    let(:record_permission) { 'forum/post.update' }

    it_behaves_like 'an updatable and permissible model', response: :ok do
      let(:invalid_attributes) { { message: '' } }
    end

    context 'when with permission' do
      include_context 'when authenticated' do
        let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }
      end

      subject(:request) { put(record_url) }

      it { expect { request && record.reload }.not_to(change(record, :author)) }
    end
  end
end
