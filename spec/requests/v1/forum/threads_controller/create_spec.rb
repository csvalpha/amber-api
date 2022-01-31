require 'rails_helper'

describe V1::Forum::ThreadsController do
  describe 'POST /forum/threads', version: 1 do
    it_behaves_like 'a creatable and permissible model' do
      let(:record) { create(:thread) }
      let(:record_url) { '/v1/forum/threads' }
      let(:record_permission) { 'forum/thread.create' }
      let(:invalid_attributes) { { title: '' } }
      let(:valid_relationships) do
        {
          author: { data: { id: record.author_id, type: 'users' } },
          category: { data: { id: record.category_id, type: 'categories' } }
        }
      end
      let(:invalid_relationships) do
        {
          author: { data: nil }, category: { data: { id: record.category_id, type: 'categories' } }
        }
      end
    end
  end
end
