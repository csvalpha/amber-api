require 'rails_helper'

describe V1::Forum::ThreadsController do
  describe 'DELETE /forum/threads/:id', version: 1 do
    let(:record) { create(:thread) }
    let(:record_url) { "/v1/forum/threads/#{record.id}" }
    let(:record_permission) { 'forum/thread.destroy' }

    it_behaves_like 'a destroyable and permissible model'
  end
end
