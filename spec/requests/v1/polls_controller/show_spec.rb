require 'rails_helper'

describe V1::PollsController do
  describe 'GET /polls/:id', version: 1 do
    it_behaves_like 'a permissible model' do
      let(:record) { create(:poll) }
      let(:record_url) { "/v1/polls/#{record.id}" }
      let(:record_permission) { 'poll.read' }
      let(:valid_request) { get(record_url) }
    end
  end
end
