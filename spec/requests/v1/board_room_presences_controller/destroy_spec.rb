require 'rails_helper'

describe V1::BoardRoomPresencesController do
  describe 'DELETE /board_room_presences/:id', version: 1 do
    it_behaves_like 'a destroyable and permissible model' do
      let(:record) { FactoryBot.create(:board_room_presence) }
      let(:record_url) { "/v1/board_room_presences/#{record.id}" }
      let(:record_permission) { 'board_room_presence.destroy' }
    end
  end
end
