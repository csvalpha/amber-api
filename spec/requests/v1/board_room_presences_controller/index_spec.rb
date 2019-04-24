require 'rails_helper'

describe V1::BoardRoomPresencesController do
  describe 'GET /board_room_presences', version: 1 do
    let(:records) { FactoryBot.create_list(:board_room_presence, 3) }
    let(:record_url) { '/v1/board_room_presences' }
    let(:record_permission) { 'board_room_presence.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'a permissible model'
    it_behaves_like 'an indexable model'
  end
end
