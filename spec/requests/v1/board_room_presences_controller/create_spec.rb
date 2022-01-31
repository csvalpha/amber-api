require 'rails_helper'

describe V1::BoardRoomPresencesController do
  describe 'POST /board_room_presences/:id', version: 1 do
    it_behaves_like 'a creatable and permissible model' do
      let(:record) { build(:board_room_presence) }
      let(:record_url) { '/v1/board_room_presences' }
      let(:record_permission) { 'board_room_presence.create' }
      let(:invalid_attributes) { { status: '' } }
    end
  end
end
