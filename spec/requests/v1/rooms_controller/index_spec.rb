require 'rails_helper'

describe V1::RoomsController do
  describe 'GET /rooms', version: 1 do
    let(:records) { create_list(:room, 3) }
    let(:record_url) { '/v1/rooms' }
    let(:record_permission) { 'room.read' }

    before { Bullet.enable = false }

    after { Bullet.enable = true }

    subject(:request) { get(record_url) }

    it_behaves_like 'a permissible model'
    it_behaves_like 'an indexable model'
  end
end
