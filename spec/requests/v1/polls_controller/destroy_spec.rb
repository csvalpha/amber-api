require 'rails_helper'

describe V1::PollsController do
  describe 'DELETE /polls/:id', version: 1 do
    it_behaves_like 'a destroyable and permissible model' do
      let(:record) { create(:poll) }
      let(:record_url) { "/v1/polls/#{record.id}" }
      let(:record_permission) { 'poll.destroy' }
    end
  end
end
