require 'rails_helper'

describe V1::RoomsController do
  describe 'GET /rooms/:id', version: 1 do
    subject(:request) { get(record_url) }

    let(:record) { create(:room) }
    let(:record_url) { "/v1/rooms/#{record.id}" }
    let(:record_permission) { 'room.read' }

    it_behaves_like 'a permissible model'
  end
end
