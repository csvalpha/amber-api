require 'rails_helper'

describe V1::Forum::ThreadsController do
  describe 'GET /forum/threads/:id', version: 1 do
    it_behaves_like 'a permissible model' do
      let(:record) { create(:thread) }
      let(:record_url) { "/v1/forum/threads/#{record.id}" }
      let(:record_permission) { 'forum/thread.read' }
      let(:valid_request) { get(record_url) }
    end
  end
end
