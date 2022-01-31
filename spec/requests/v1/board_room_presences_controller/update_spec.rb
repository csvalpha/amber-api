require 'rails_helper'

describe V1::BoardRoomPresencesController do
  describe 'PUT /board_room_presences/:id', version: 1 do
    it_behaves_like 'an updatable and permissible model' do
      let(:record) { create(:board_room_presence) }
      let(:record_url) { "/v1/board_room_presences/#{record.id}" }
      let(:record_permission) { 'board_room_presence.update' }
      let(:invalid_attributes) { { status: '' } }
    end
  end
end
